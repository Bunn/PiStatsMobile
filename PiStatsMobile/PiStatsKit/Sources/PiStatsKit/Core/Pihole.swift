//
//  PiHole.swift
//  PiHoleStats
//
//  Created by Fernando Bunn on 24/05/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation
import SwiftHole
import PiMonitor
import Combine
import os.log

public class Pihole: Identifiable, ObservableObject {
    private let log = Logger().osLog(describing: Pihole.self)
    public private(set) var metrics: PiMetrics?
    public private(set) var active = false
    private lazy var keychainToken = APIToken(accountName: self.id.uuidString)
    private let servicesTimeout: TimeInterval = 10
    
    public var displayName: String?
    public var address: String
    public var piMonitorPort: Int?
    public var hasPiMonitor: Bool = false
    public let id: UUID
    public var secure: Bool

    @Published public var actionError: String?
    @Published public var pollingError: String?

    @Published public private(set) var summary: Summary? {
        didSet {
            if summary?.status.lowercased() == "enabled" {
                active = true
                os_log("%@ summary has enabled status", log: self.log, type: .debug, address)
            } else {
                active = false
                os_log("%@ summary has disabled status", log: self.log, type: .debug, address)
            }
        }
    }

    public var apiToken: String {
        get {
            keychainToken.token
        }
        set {
            keychainToken.token = newValue
        }
    }
    
    public var port: Int? {
        getPort(address)
    }
    
    public var host: String {
        address.components(separatedBy: ":").first ?? ""
    }
    
    public var title: String {
        if let name = displayName {
            return name
        }
        return host
    }
    
    private var service: SwiftHole {
        SwiftHole(host: host, port: port, apiToken: apiToken, timeoutInterval: servicesTimeout, secure: secure)
    }
    
    private var piMonitorService: PiMonitor {
        PiMonitor(host: host, port: piMonitorPort ?? 8088, timeoutInterval: servicesTimeout, secure: secure)
    }
  
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        address = try container.decode(String.self, forKey: .address)
        displayName = try container.decode(String?.self, forKey: .displayName)
       
        do {
            piMonitorPort = try container.decode(Int?.self, forKey: .piMonitorPort)
        } catch {
            piMonitorPort = nil
        }
        
        do {
            hasPiMonitor = try container.decode(Bool.self, forKey: .hasPiMonitor)
        } catch {
            hasPiMonitor = false
        }
        
        do {
            secure = try container.decode(Bool.self, forKey: .secure)
        } catch {
            secure = false
        }
    }
    
    public init(address: String, apiToken: String? = nil, piHoleID: UUID? = nil, secure: Bool = false) {
        self.address = address
        self.secure = secure

        if let piHoleID = piHoleID {
            self.id = piHoleID
        } else {
            self.id = UUID()
        }
        
        if let apiToken = apiToken {
            keychainToken.token = apiToken
        }
    }
    
    public static func previewData() -> Pihole {
        let pihole = Pihole(address: "127.0.0.1")
        pihole.hasPiMonitor = true
        return pihole
    }
    
    private func getPort(_ address: String) -> Int? {
        let split = address.components(separatedBy: ":")
        guard let port = split.last else { return nil }
        return Int(port)
    }
}

// MARK: Network Methods

extension Pihole {
    
    public func updateMetrics(completion: @escaping (PiMonitorError?) -> Void) {
        piMonitorService.fetchMetrics { result in
            switch result {
            case .success(let metrics):
                self.metrics = metrics
                completion(nil)
            case .failure(let error):
                self.metrics = nil
                completion(error)
            }
        }
    }
    
    public func updateSummary(completion: @escaping (SwiftHoleError?) -> Void) {
        service.fetchSummary { result in
            switch result {
            case .success(let summary):
                self.summary = summary
                completion(nil)
            case .failure(let error):
                self.summary = nil
                completion(error)
            }
        }
    }
    
    public func enablePiHole(completion: @escaping (Result<Void, SwiftHoleError>) -> Void) {
        service.enablePiHole { result in
            switch result {
            case .success:
                self.active = true
                os_log("%@ enable request success", log: self.log, type: .debug, self.address)
                completion(result)
            case .failure:
                os_log("%@ enable request failure", log: self.log, type: .debug, self.address)
                completion(result)
            }
        }
    }
    
    public func disablePiHole(seconds: Int = 0, completion: @escaping (Result<Void, SwiftHoleError>) -> Void) {
        service.disablePiHole(seconds: seconds) { result in
            switch result {
            case .success:
                self.active = false
                os_log("%@ disable request success", log: self.log, type: .debug, self.address)
                completion(result)
            case .failure:
                os_log("%@ disable request failure", log: self.log, type: .debug, self.address)
                completion(result)
            }
        }
    }

    public func disable(for seconds: Int = 0) async throws {
        try await withCheckedThrowingContinuation { continuation in
            disablePiHole(seconds: seconds) { result in
                continuation.resume(with: result)
            }
        }
    }
}

// MARK: I/O Methods

extension Pihole {
    private static let piHoleListKey = "PiHoleStatsPiHoleList"
    
    public func delete() {
        var piholeList = Pihole.restoreAll()
        
        if let index = piholeList.firstIndex(of: self) {
            piholeList.remove(at: index)
        }
        save(piholeList)
        self.keychainToken.delete()
    }
    
    public func save() {
        var piholeList = Pihole.restoreAll()
        if let index = piholeList.firstIndex(where: { $0.id == self.id }) {
            piholeList[index] = self
        } else {
            piholeList.append(self)
        }
        save(piholeList)
    }
    
    private func save(_ list: [Pihole]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            UserDefaults.shared().set(encoded, forKey: Pihole.piHoleListKey)
        }
    }
    
    public static func restoreAll() -> [Pihole] {
        if let piHoleList = UserDefaults.shared().object(forKey: Pihole.piHoleListKey) as? Data {
            let decoder = JSONDecoder()
            
            do {
                let list = try decoder.decode([Pihole].self, from: piHoleList)
                return list
            } catch {
                print("error \(error)")
                return [Pihole]()
            }
        }
        return [Pihole]()
    }
    
    public static func restore(_ uuid: UUID) -> Pihole? {
        return Pihole.restoreAll().filter { $0.id == uuid }.first
    }
}

extension Pihole: Hashable {
    public static func == (lhs: Pihole, rhs: Pihole) -> Bool {
         return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Pihole: Codable {
    
    public enum CodingKeys: CodingKey {
        case id
        case address
        case displayName
        case piMonitorPort
        case hasPiMonitor
        case secure
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(address, forKey: .address)
        try container.encode(piMonitorPort, forKey: .piMonitorPort)
        try container.encode(hasPiMonitor, forKey: .hasPiMonitor)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(secure, forKey: .secure)
    }
}
