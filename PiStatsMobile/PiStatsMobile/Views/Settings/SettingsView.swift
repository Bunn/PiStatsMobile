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
            Section(header: Text(UIConstants.Strings.settingsSectionDisplay)) {
                Toggle(isOn: $userPreferences.displayStatsAsList) {
                    Label(UIConstants.Strings.settingsDisplayAsList, systemImage: UIConstants.SystemImages.settingsDisplayAsList)
                }
                Toggle(isOn: $userPreferences.displayStatsIcons) {
                    Label(UIConstants.Strings.settingsDisplayIcons, systemImage: UIConstants.SystemImages.settingsDisplayIcons)
                }
            }
            Section(header: Text(UIConstants.Strings.settingsSectionActions)) {
                Toggle(isOn: $userPreferences.disablePermanently) {
                    Label(UIConstants.Strings.settingsAlwaysDisablePermanently, systemImage: UIConstants.SystemImages.settingsDisablePermanently)
                }
            }
        }.listStyle(InsetGroupedListStyle())
        .navigationTitle(UIConstants.Strings.settings)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserPreferences())
    }
}
