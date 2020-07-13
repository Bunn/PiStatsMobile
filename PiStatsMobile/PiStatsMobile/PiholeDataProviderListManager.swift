//
//  PiholeDataProviderListManager.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 08/07/2020.
//

import Foundation
import UIKit
import Combine

class PiholeDataProviderListManager: ObservableObject {
    @Published var providerList = [PiholeDataProvider]()
    private var piholes = Pihole.restoreAll()
    private var offlineBadgeCancellable: AnyCancellable?
    var shouldUpdateIconBadgeWithOfflinePiholes: Bool = false

    var isEmpty: Bool {
        return providerList.count == 0
    }
    
    init() {
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
        setupCancellables()
    }
    
    private func addPiholeToList(_ pihole: Pihole){
        let dataprovider = PiholeDataProvider(piholes: [pihole])
        dataprovider.startPolling()
        objectWillChange.send()
        providerList.append(dataprovider)
    }
    
    func updateList(){
        providerList.forEach {
            $0.stopPolling()
        }
        providerList.removeAll()
        piholes = Pihole.restoreAll()
        objectWillChange.send()
        setupProviders()
    }
}
