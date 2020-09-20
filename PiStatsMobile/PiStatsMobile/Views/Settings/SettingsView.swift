//
//  SettingsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 09/07/2020.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userPreferences: UserPreferences

    var body: some View {
        List {
            Section(header: Text("Interface")) {
                Toggle(isOn: $userPreferences.displayStatsAsList) {
                    Label(UIConstants.Strings.settingsDisplayAsList, systemImage: UIConstants.SystemImages.settingsDisplayAsList)
                }
                
                Toggle(isOn: $userPreferences.displayStatsIcons) {
                    Label(UIConstants.Strings.settingsDisplayIcons, systemImage: UIConstants.SystemImages.settingsDisplayIcons)
                }
                
                Toggle(isOn: $userPreferences.displayAllPiholes) {
                    Label(UIConstants.Strings.settingsDisplayAllPiholesInSingleCard, systemImage: UIConstants.SystemImages.settingsDisplayAllPiholesInSingleCard)
                }
            }
            
            Section(header: Text("Enable / Disable")) {
                
                Toggle(isOn: $userPreferences.disablePermanently.animation()) {
                    Label(UIConstants.Strings.settingsAlwaysDisablePermanently, systemImage: UIConstants.SystemImages.settingsDisablePermanently)
                }
                
                if userPreferences.disablePermanently == false {
                    NavigationLink(destination: CustomDurationsView()) {
                        Label("Customize disable times", systemImage: "clock")
                    }
                }
            }
            
            Section(header: Text("About"), footer: Text("Version 1.1")) {
                
                Label("Pi Stats source code", systemImage: "terminal")
                Label("Pi Stats for macOS", systemImage: "desktopcomputer")
                Label("Leave a review on the App Store", systemImage: "heart")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(UIConstants.Strings.settingsNavigationTitle)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserPreferences())
    }
}
