//
//  SettingsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 09/07/2020.
//

import SwiftUI
import StoreKit

fileprivate struct PiStatsURL {
    static let review = URL(string: "https://apps.apple.com/us/app/pi-stats-mobile/id1523024268?action=write-review&mt=8")!
    static let piStatsMobileGitHub = URL(string: "https://github.com/Bunn/PiStatsMobile")!
    static let piStatsMacOSGitHub = URL(string: "https://github.com/Bunn/PiStats")!
}

struct SettingsView: View {
    @EnvironmentObject private var userPreferences: UserPreferences

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var body: some View {
        List {
            Section(header: Text(UIConstants.Strings.Preferences.sectionInterface)) {
                Toggle(isOn: $userPreferences.displayStatsAsList) {
                    Label(UIConstants.Strings.Preferences.displayAsList, systemImage: UIConstants.SystemImages.settingsDisplayAsList)
                }
                
                Toggle(isOn: $userPreferences.displayStatsIcons) {
                    Label(UIConstants.Strings.Preferences.displayIcons, systemImage: UIConstants.SystemImages.settingsDisplayIcons)
                }
                
                Toggle(isOn: $userPreferences.displayAllPiholes) {
                    Label(UIConstants.Strings.Preferences.displayAllPiholesInSingleCard, systemImage: UIConstants.SystemImages.settingsDisplayAllPiholesInSingleCard)
                }
            }
            
            Section(header: Text(UIConstants.Strings.Preferences.sectionEnableDisable)) {
                
                Toggle(isOn: $userPreferences.disablePermanently.animation()) {
                    Label(UIConstants.Strings.Preferences.alwaysDisablePermanently, systemImage: UIConstants.SystemImages.settingsDisablePermanently)
                }
                
                if userPreferences.disablePermanently == false {
                    NavigationLink(destination: CustomDurationsView()) {
                        Label(UIConstants.Strings.Preferences.customizeDisableTimes, systemImage: UIConstants.SystemImages.customizeDisableTimes)
                    }
                }
            }
            
            Section(header: Text(UIConstants.Strings.Preferences.sectionPiMonitor)) {
                
                VStack(alignment: .leading) {
                    Label(UIConstants.Strings.Preferences.piMonitorTemperature, systemImage: UIConstants.SystemImages.piMonitorTemperature)
                    
                    Picker(selection: userPreferences.$temperatureScale, label: Text("")) {
                        Text(UIConstants.Strings.Preferences.temperatureScaleCelsius).tag(0)
                        Text(UIConstants.Strings.Preferences.temperatureScaleFahrenheit).tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            
            Section(header: Text(UIConstants.Strings.Preferences.about), footer: Text("\(UIConstants.Strings.Preferences.version) \(appVersion)")) {
                
                Button(action: {
                    openGithubPage()
                }, label: {
                    Label(UIConstants.Strings.Preferences.piStatsSourceCode, systemImage: UIConstants.SystemImages.piStatsSourceCode)
                        .foregroundColor(.primary)
                })
                
                Button(action: {
                    openPiStatsMacOS()
                }, label: {
                    Label(UIConstants.Strings.Preferences.piStatsForMacOS, systemImage: UIConstants.SystemImages.piStatsMacOS)
                        .foregroundColor(.primary)
                })
                
                Button(action: {
                    leaveAppReview()
                }, label: {
                    Label(UIConstants.Strings.Preferences.leaveReview, systemImage: UIConstants.SystemImages.leaveReview)
                        .foregroundColor(.primary)
                })
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(UIConstants.Strings.settingsNavigationTitle)
    }
    
    private func leaveAppReview() {
        UIApplication.shared.open(PiStatsURL.review, options: [:], completionHandler: nil)
    }
    
    private func openGithubPage() {
        UIApplication.shared.open(PiStatsURL.piStatsMobileGitHub)
    }
    
    private func openPiStatsMacOS() {
        UIApplication.shared.open(PiStatsURL.piStatsMacOSGitHub)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserPreferences())
    }
}
