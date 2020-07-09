//
//  PiStatsMobileApp.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 02/07/2020.
//

import SwiftUI

@main
struct PiStatsMobileApp: App {
    @StateObject private var piholeProviderListManager = PiholeDataProviderListManager()
    @StateObject private var userPreferences = UserPreferences()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(piholeProviderListManager)
                .environmentObject(userPreferences)
        }
    }
}
