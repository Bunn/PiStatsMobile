//
//  piholeservice.swift
//  piholestats
//
//  Created by Fernando Bunn on 24/05/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation
import SwiftHole
import SwiftUI
import PiMonitor
import Combine

public class PiholeDataProvider: ObservableObject, Identifiable {

    public enum PiholeStatus {
        case allEnabled
        case allDisabled
        case enabledAndDisabled
    }
    
    public enum PollingMode {
        case foreground
        case background
    }
    
    public private(set) var pollingTimeInterval: TimeInterval = 3
    private var timer: Timer?
    public private(set) var piholes: [Pihole]
    public let id = UUID()

    private var piSummaryCancellables: [AnyCancellable]?
    private var piPollingErrorCancellables: [AnyCancellable]?
    private var piActionErrorCancellables: [AnyCancellable]?
    
    @Published public private(set) var totalQueries = ""
    @Published public private(set) var queriesBlocked = ""
    @Published public private(set) var percentBlocked = ""
    @Published public private(set) var domainsOnBlocklist = ""
    @Published public private(set) var hasErrorMessages = false
    @Published public private(set) var status: PiholeStatus = .allDisabled
    @Published public private(set) var name = ""
    @Published public private(set) var pollingErrors = [String]()
    @Published public private(set) var actionErrors = [String]()
    @Published public private(set) var offlinePiholesCount = 0

    @Published public private(set) var uptime = ""
    @Published public private(set) var memoryUsage = ""
    @Published public private(set) var loadAverage = ""
    @Published public private(set) var temperature = ""

    public var canDisplayMetrics: Bool {
        return piholes.allSatisfy {
            return $0.hasPiMonitor
        }
    }

    public var canDisplayEnableDisableButton: Bool {
        return !piholes.allSatisfy {
            return $0.apiToken.isEmpty == true
        }
    }
    
    private lazy var percentageFormatter: NumberFormatter = {
        let n = NumberFormatter()
        n.numberStyle = .percent
        n.minimumFractionDigits = 2
        n.maximumFractionDigits = 2
        return n
    }()

    private lazy var numberFormatter: NumberFormatter = {
        let n = NumberFormatter()
        n.numberStyle = .decimal
        n.maximumFractionDigits = 0
        return n
    }()
    
    public init(piholes: [Pihole]) {
        self.piholes = piholes
        if piholes.count > 1 {
            self.name = UIConstants.Strings.allPiholesTitle
        } else if let firstPihole = piholes.first {
            self.name = firstPihole.title
        }
        setupCancellables()
    }
    
    public func updatePollingMode(_ pollingMode: PollingMode) {
        switch pollingMode {
        case .background:
            pollingTimeInterval = 10
        case .foreground:
            pollingTimeInterval = 3
        }
        startPolling()
    }
    
    public func startPolling() {
        self.fetchSummaryData()
        self.fetchMetricsData()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: pollingTimeInterval, repeats: true) { _ in
            self.fetchSummaryData()
            self.fetchMetricsData()
        }
    }
    
    public func stopPolling() {
        timer?.invalidate()
    }
    
    public func resetErrorMessage() {
        piholes.forEach { pihole in
            pihole.actionError = nil
            pihole.pollingError = nil
        }
        updateErrorMessageStatus()
    }
    
    public func add(_ pihole: Pihole) {
        objectWillChange.send()
        piholes.append(pihole)
        updateStatus()
        updateErrorMessageStatus()
    }
    
    public func remove(_ pihole: Pihole) {
        objectWillChange.send()
        if let index = piholes.firstIndex(of: pihole) {
            piholes.remove(at: index)
        }
        
        updateStatus()
        updateErrorMessageStatus()
    }
    
    public func setupCancellables() {

        piActionErrorCancellables = piholes.map {
            $0.$actionError.receive(on: DispatchQueue.main).sink { [weak self] value in
                self?.updateErrorMessageStatus()
            }
        }
        
        piPollingErrorCancellables = piholes.map {
            $0.$pollingError.receive(on: DispatchQueue.main).sink { [weak self] value in
                self?.updateErrorMessageStatus()
            }
        }
        
        piSummaryCancellables = piholes.map {
            $0.$summary.receive(on: DispatchQueue.main).sink { [weak self] value in
                self?.updateData()
            }
        }
    }
    
    public func disablePiHole(seconds: Int = 0) {
        piholes.forEach { pihole in
            pihole.disablePiHole(seconds: seconds) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        pihole.actionError = nil
                    case .failure(let error):
                        pihole.actionError = self.errorMessage(error)
                    }
                }
            }
        }
    }
    
    public func enablePiHole() {
        piholes.forEach { pihole in
            pihole.enablePiHole { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        pihole.actionError = nil
                    case .failure(let error):
                        pihole.actionError = self.errorMessage(error)
                    }
                }
            }
        }
    }
    
    private func errorMessage(_ error: SwiftHoleError) -> String {
        switch error {
        case .malformedURL:
            return UIConstants.Strings.Error.invalidURL
        case .invalidDecode(let decodeError):
            return  "\(UIConstants.Strings.Error.decodeResponseError): \(decodeError.localizedDescription)"
        case .noAPITokenProvided:
            return  UIConstants.Strings.Error.noAPITokenProvided
        case .sessionError(let sessionError):
            return  "\(UIConstants.Strings.Error.sessionError): \(sessionError.localizedDescription)"
        case .invalidResponseCode(let responseCode):
            return  "\(UIConstants.Strings.Error.sessionError): \(responseCode)"
        case .invalidResponse:
            return  UIConstants.Strings.Error.invalidResponse
        case .invalidAPIToken:
            return  UIConstants.Strings.Error.invalidAPIToken
        case .cantAddNewListItem(_):
            return UIConstants.Strings.Error.cantAddNewItem
        }
    }
    
    private func updateMetrics(_ metrics: PiMetrics?) {
        guard let metrics = metrics else {
            loadAverage = "-"
            uptime = "-"
            memoryUsage = "-"
            temperature = "-"
            return
        }
         loadAverage = metrics.loadAverage.map({"\($0)"}).joined(separator: ", ")
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        let timeInterval =  TimeInterval(metrics.uptime)
        uptime = formatter.string(from: timeInterval) ?? "-"

        let usedMemory = metrics.memory.totalMemory - metrics.memory.availableMemory
        let percentageUsed = Double(usedMemory) / Double(metrics.memory.totalMemory)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        memoryUsage = numberFormatter.string(for: percentageUsed) ?? "-"
        
        if UserPreferences.shared.temperatureScaleType == .celsius {
            temperature = "\(String(metrics.socTemperature)) \(UIConstants.Strings.temperatureScaleCelsius)"
        } else {
            let converted = metrics.socTemperature * (9.0/5.0) + 32.0
            let fahrenheit = String(format: "%.01f", converted)
            temperature = "\(fahrenheit) \(UIConstants.Strings.temperatureScaleFahrenheit)"
        }
    }
    
    public func fetchMetricsData(completion: (() -> ())? = nil) {
        if !canDisplayMetrics {
            completion?()
            return
        }
        let dispatchGroup = DispatchGroup()
        
        piholes.forEach { pihole in
            dispatchGroup.enter()
            pihole.updateMetrics { error in
                DispatchQueue.main.async {
                    self.updateMetrics(pihole.metrics)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
          completion?()
        }
    }
    
    public func fetchSummaryData(completion: (() -> ())? = nil) {
        let dispatchGroup = DispatchGroup()

        piholes.forEach { pihole in
            dispatchGroup.enter()
            pihole.updateSummary { error in
                DispatchQueue.main.async {
                    if let error = error {
                        pihole.pollingError = self.errorMessage(error)
                    } else {
                        pihole.pollingError = nil
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.updateData()
            completion?()
        }
    }
    
    private func updateData() {
        let sumDNSQueries = piholes.compactMap { $0.summary }.reduce(0) { value, pihole in value + pihole.dnsQueriesToday }
        totalQueries = numberFormatter.string(from: NSNumber(value: sumDNSQueries)) ?? "-"
        
        let sumQueriesBlocked = piholes.compactMap { $0.summary }.reduce(0) { value, pihole in value + pihole.adsBlockedToday }
        queriesBlocked = numberFormatter.string(from: NSNumber(value: sumQueriesBlocked)) ?? "-"
        
        let sumDomainOnBlocklist = piholes.compactMap { $0.summary }.reduce(0) { value, pihole in value + pihole.domainsBeingBlocked }
        domainsOnBlocklist = numberFormatter.string(from: NSNumber(value: sumDomainOnBlocklist)) ?? "-"
        
        let percentage = sumDNSQueries == 0 ? 0 : Double(sumQueriesBlocked) / Double(sumDNSQueries)
        percentBlocked = percentageFormatter.string(from: NSNumber(value: percentage)) ?? "-"
        
        updateStatus()
        updateErrorMessageStatus()
    }
    
    private func updateStatus() {
        offlinePiholesCount = piholes.reduce(0) { counter, item in
            if item.active != false {
                return counter + 1
            }
            return counter
        }
        
        let allStatus = Set(piholes.map { $0.active })
        if allStatus.count > 1 {
            status = .enabledAndDisabled
        } else if allStatus.randomElement() == false {
            status = .allDisabled
        } else {
            status = .allEnabled
        }
    }
    
    private func updateErrorMessageStatus() {
        pollingErrors = piholes.compactMap{ $0.pollingError}
        actionErrors = piholes.compactMap{ $0.actionError}
        hasErrorMessages =  pollingErrors.count != 0 || actionErrors.count != 0
    }
}

// MARK: - Preview Support

public extension PiholeDataProvider {

    static func previewData() -> PiholeDataProvider {
        let provider =  PiholeDataProvider.init(piholes: [Pihole.previewData()])
        provider.totalQueries = "1245"
        provider.queriesBlocked = "1245"
        provider.percentBlocked = "12,3%"
        provider.domainsOnBlocklist = "12,345"
        provider.status = .allEnabled

        provider.temperature = "23 ºC"
        provider.memoryUsage = "50%"
        provider.loadAverage = "0.1, 0.3, 0.6"
        provider.uptime = "23h 2m"
        return provider
    }

    static func previewDataAlternate() -> PiholeDataProvider {
        let provider =  PiholeDataProvider.init(piholes: [Pihole.previewData()])
        provider.totalQueries = "1768"
        provider.queriesBlocked = "1524"
        provider.percentBlocked = "11,2%"
        provider.domainsOnBlocklist = "12,389"
        provider.status = .allEnabled

        provider.temperature = "22 ºC"
        provider.memoryUsage = "53%"
        provider.loadAverage = "0.1, 0.2, 0.8"
        provider.uptime = "26h 8m"
        return provider
    }

}
