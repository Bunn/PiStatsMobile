//
//  PiStatsMobileApp.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 02/07/2020.
//

import SwiftUI
import Combine

final class DataModel: ObservableObject {
    let piholeProviderListManager = PiholeDataProviderListManager()
    let userPreferences = UserPreferences.shared
    private var offlineBadgeCancellable: AnyCancellable?
    
    init() {
        setupCancellables()
    }
    
    private func setupCancellables() {
        offlineBadgeCancellable = userPreferences.$displayIconBadgeForOfflinePiholes.receive(on: DispatchQueue.main).sink { [weak self] value in
            self?.piholeProviderListManager.shouldUpdateIconBadgeWithOfflinePiholes = value
        }
    }
}

@main
struct PiStatsMobileApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var dataModel = DataModel()

    var body: some Scene {
        WindowGroup {
         ContentView()
            .environmentObject(dataModel.piholeProviderListManager)
            .environmentObject(dataModel.userPreferences)
        }
  
    }
}
