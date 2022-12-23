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

class PiholeDataProvider: ObservableObject, Identifiable {
    
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
    
    enum PiholeStatus {
        case allEnabled
        case allDisabled
        case enabledAndDisabled
    }
    
    enum PollingMode {
        case foreground
        case background
    }
    
    private(set) var pollingTimeInterval: TimeInterval = 3
    private var timer: Timer?
    private(set) var piholes: [Pihole]
    let id = UUID()
    
    private var piSummaryCancellables: [AnyCancellable]?
    private var piPollingErrorCancellables: [AnyCancellable]?
    private var piActionErrorCancellables: [AnyCancellable]?
    
    @Published private(set) var totalQueries = ""
    @Published private(set) var queriesBlocked = ""
    @Published private(set) var percentBlocked = ""
    @Published private(set) var domainsOnBlocklist = ""
    @Published private(set) var hasErrorMessages = false
    @Published private(set) var status: PiholeStatus = .allDisabled
    @Published private(set) var name = ""
    @Published private(set) var pollingErrors = [String]()
    @Published private(set) var actionErrors = [String]()
    @Published private(set) var offlinePiholesCount = 0
    
    @Published private(set) var uptime = ""
    @Published private(set) var memoryUsage = ""
    @Published private(set) var loadAverage = ""
    @Published private(set) var temperature = ""

    var canDisplayMetrics: Bool {
        return piholes.allSatisfy {
            return $0.hasPiMonitor
        }
    }

     var canDisplayEnableDisableButton: Bool {
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
    
    init(piholes: [Pihole]) {
        self.piholes = piholes
        if piholes.count > 1 {
            self.name = UIConstants.Strings.allPiholesTitle
        } else if let firstPihole = piholes.first {
            self.name = firstPihole.title
        }
        setupCancellables()
    }
    
    func updatePollingMode(_ pollingMode: PollingMode) {
        switch pollingMode {
        case .background:
            pollingTimeInterval = 10
        case .foreground:
            pollingTimeInterval = 3
        }
        startPolling()
    }
    
    func startPolling() {
        self.fetchSummaryData()
        self.fetchMetricsData()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: pollingTimeInterval, repeats: true) { _ in
            self.fetchSummaryData()
            self.fetchMetricsData()
        }
    }
    
    func stopPolling() {
        timer?.invalidate()
    }
    
    func resetErrorMessage() {
        piholes.forEach { pihole in
            pihole.actionError = nil
            pihole.pollingError = nil
        }
        updateErrorMessageStatus()
    }
    
    func add(_ pihole: Pihole) {
        objectWillChange.send()
        piholes.append(pihole)
        updateStatus()
        updateErrorMessageStatus()
    }
    
    func remove(_ pihole: Pihole) {
        objectWillChange.send()
        if let index = piholes.firstIndex(of: pihole) {
            piholes.remove(at: index)
        }
        
        updateStatus()
        updateErrorMessageStatus()
    }
    
    func setupCancellables() {
      
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
    
    func disablePiHole(seconds: Int = 0) {
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
    
    func enablePiHole() {
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
    
    func fetchMetricsData(completion: (() -> ())? = nil) {
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
    
    func fetchSummaryData(completion: (() -> ())? = nil) {
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
