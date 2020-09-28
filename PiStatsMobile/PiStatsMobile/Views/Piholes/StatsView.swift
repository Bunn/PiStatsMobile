//
//  StatsView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var dataProvider: PiholeDataProvider
    @EnvironmentObject private var userPreferences: UserPreferences
    @State private var isShowingDisableOptions = false

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Geometry.defaultPadding) {
            StatusHeaderView(dataProvider: dataProvider)
            
            VStack {
                ForEach(dataProvider.pollingErrors, id: \.self) { error in
                    Label {
                        Text(error)
                            .fixedSize(horizontal: false, vertical: true)
                    } icon: {
                        Image(systemName: UIConstants.SystemImages.errorMessageWarning)
                            .foregroundColor(UIConstants.Colors.errorMessage)
                    }
                    .font(.headline)
                }
            }
            
            if userPreferences.displayStatsAsList {
                statsList()
            } else {
                statsGrid()
            }
            
            if dataProvider.canDisplayMetrics && dataProvider.piholes.count == 1 {
                Divider()
                MetricsView(dataProvider: dataProvider)
            }
            
            if dataProvider.canDisplayEnableDisableButton {
                Divider()
                if dataProvider.status == .allDisabled {
                    enableButton()
                } else {
                    disableButton()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
        .shadow(radius: UIConstants.Geometry.shadowRadius)
        .padding()
        
    }
    
    private func statsList() -> some View {
        return VStack (alignment: .leading, spacing: 5){
            StatsItemView(displayIcons: userPreferences.displayStatsIcons, layoutType: .list, contentType: .totalQueries, value: dataProvider.totalQueries)
            StatsItemView(displayIcons: userPreferences.displayStatsIcons, layoutType: .list, contentType: .queriesBlocked, value: dataProvider.queriesBlocked)
            StatsItemView(displayIcons: userPreferences.displayStatsIcons, layoutType: .list, contentType: .percentBlocked, value: dataProvider.percentBlocked)
            StatsItemView(displayIcons: userPreferences.displayStatsIcons, layoutType: .list, contentType: .domainsOnBlockList, value: dataProvider.domainsOnBlocklist)
        }
    }
    
    private func statsGrid() -> some View {
        return Group {
            HStack {
                StatsItemView(displayIcons: userPreferences.displayStatsIcons, contentType: .totalQueries, value: dataProvider.totalQueries)
                StatsItemView(displayIcons: userPreferences.displayStatsIcons, contentType: .queriesBlocked, value: dataProvider.queriesBlocked)
            }
            HStack {
                StatsItemView(displayIcons: userPreferences.displayStatsIcons, contentType: .percentBlocked, value: dataProvider.percentBlocked)
                StatsItemView(displayIcons: userPreferences.displayStatsIcons, contentType: .domainsOnBlockList, value: dataProvider.domainsOnBlocklist)
            }
        }
    }
    
    
    private func disableButton() -> some View {
        Button(action: {
            if userPreferences.disablePermanently {
                dataProvider.disablePiHole()
            } else {
                isShowingDisableOptions = true
            }
            
        }, label: {
            HStack (spacing: 0) {
                Label(UIConstants.Strings.disableButton, systemImage: UIConstants.SystemImages.disablePiholeButton)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color(.systemBlue))
            .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
        })
        .actionSheet(isPresented: $isShowingDisableOptions) {
            disableTimeActionSheet()
        }
    }
    
    func disableTimeActionSheet() -> ActionSheet {
        let disableTimes = userPreferences.disableTimes
        
        let intervalFormatter = DateComponentsFormatter()
        intervalFormatter.unitsStyle = .full
        intervalFormatter.allowedUnits = [.second, .minute, .hour]
        
        var buttons = disableTimes.map { timeInterval in
            Alert.Button.default(Text(intervalFormatter.string(from: timeInterval) ?? "-"), action: {
                dataProvider.disablePiHole(seconds: Int(timeInterval))
            } )
        }
       
        buttons.append(.destructive(Text(UIConstants.Strings.disablePiholeOptionsPermanently)) {
            dataProvider.disablePiHole()
        })
        
        buttons.append(.cancel())
        return ActionSheet(title: Text(UIConstants.Strings.disablePiholeOptionsTitle), buttons: buttons)
    }
    
    private func enableButton() -> some View {
        Button(action: {
            dataProvider.enablePiHole()
        }, label: {
            HStack (spacing: 0) {
                Label(UIConstants.Strings.enableButton, systemImage: UIConstants.SystemImages.enablePiholeButton)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color(.systemBlue))
            .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
        })
    }
}


struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(dataProvider: PiholeDataProvider.previewData())
            .environmentObject(UserPreferences())
    }
}
