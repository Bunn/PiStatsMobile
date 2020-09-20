//
//  SettingsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 09/07/2020.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    @State private var shouldApplyAnimation = false

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
                
                Toggle(isOn: $userPreferences.disablePermanently) {
                    Label(UIConstants.Strings.settingsAlwaysDisablePermanently, systemImage: UIConstants.SystemImages.settingsDisablePermanently)
                }
                
                if userPreferences.disablePermanently == false {
                    Button(action: {
                        customDurationPresented.toggle()
                    }) {
                        Label("Customize disable times", systemImage: "clock")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(isPresented: $customDurationPresented, content: {
            Text("test")
        })
        .navigationTitle(UIConstants.Strings.settingsNavigationTitle)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserPreferences())
    }
}
