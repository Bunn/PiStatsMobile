//
//  PiholeDataProviderListManager.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 08/07/2020.
//

import Foundation
import UIKit
import Combine

public class PiholeDataProviderListManager: ObservableObject {

    public static func previewData() -> PiholeDataProviderListManager {
        let provider =  PiholeDataProvider.init(piholes: [Pihole.previewData()])
        let manager = PiholeDataProviderListManager()
        manager.providerList = [provider]
        return manager
    }

    @Published public var providerList = [PiholeDataProvider]()
    @Published public var allPiholesProvider = PiholeDataProvider(piholes: [])

    private var piholes = Pihole.restoreAll()
    private var offlineBadgeCancellable: AnyCancellable?
    public var shouldUpdateIconBadgeWithOfflinePiholes: Bool = false

    public var isEmpty: Bool {
        return providerList.count == 0
    }
    
    public init() {
        setupProviders()
    }
    
    private func setupCancellables() {
        offlineBadgeCancellable = Publishers.MergeMany(providerList.map { $0.$offlinePiholesCount } ).sink {[weak self] value in
            let result = self?.providerList.reduce(0) { counter, provider in
                counter + provider.offlinePiholesCount
            }
            self?.setupApplicationBadge(result ?? 0)
        }
    }
    
    private func setupApplicationBadge(_ badgeCount: Int) {
        if shouldUpdateIconBadgeWithOfflinePiholes == false {
            return
        }
        //UIApplication.shared.applicationIconBadgeNumber = badgeCount
    }
    
    private func setupProviders() {
        piholes.forEach { pihole in
            addPiholeToList(pihole)
        }
        
        allPiholesProvider = PiholeDataProvider(piholes: piholes)
        setupCancellables()
    }
    
    private func addPiholeToList(_ pihole: Pihole){
        let dataprovider = PiholeDataProvider(piholes: [pihole])
        dataprovider.startPolling()
        objectWillChange.send()
        providerList.append(dataprovider)
    }
    
    public func updateList(){
        providerList.forEach {
            $0.stopPolling()
        }
        providerList.removeAll()
        piholes = Pihole.restoreAll()
        objectWillChange.send()
        setupProviders()
    }
}
