//
//  PiholeDataProviderListManager.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 08/07/2020.
//

import Foundation

class PiholeDataProviderListManager: ObservableObject {
    @Published var providerList = [PiholeDataProvider]()
    
    
    private var piholes = Pihole.restoreAll()
    var isEmpty: Bool {
        return providerList.count == 0
    }
    
    init() {
        setupProviders()
    }
    
    private func setupProviders() {
        piholes.forEach { pihole in
           add(pihole)
        }
    }
    
    func add(_ pihole: Pihole){
        let dataprovider = PiholeDataProvider(piholes: [pihole])
        dataprovider.startPolling()
        objectWillChange.send()
        providerList.append(dataprovider)
    }
}
