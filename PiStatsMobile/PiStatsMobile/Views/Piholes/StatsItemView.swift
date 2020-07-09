//
//  StatsItemView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI


struct StatsItemView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    let type: StatsItemType
    let label: String
    
    var body: some View {
        if userPreferences.displayStatsAsList {
            ListStatView(type: type, label: label)
        } else {
            RoundedStatView(type: type, label: label)
        }
    }
}

fileprivate struct ListStatView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    let type: StatsItemType
    let label: String
    
    var body: some View {
        HStack {
            Label {
                Text(type.title)
                    .foregroundColor(.white)
                    .font(.subheadline)
            } icon: {
                Group {
                    if userPreferences.displayStatsIcons {
                        Image(systemName: type.imageName)
                    } else {
                        Image(systemName: "circle.fill")
                    }
                }
                .foregroundColor(type.color)
                .font(.subheadline)
                
            }
            Spacer()
            Text(label)
        }
    }
}


fileprivate struct RoundedStatView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    let type: StatsItemType
    let label: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(type.title)
                .foregroundColor(.white)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                if userPreferences.displayStatsIcons {
                    Label(label, systemImage: type.imageName)
                        .foregroundColor(.white)
                        .font(.headline)
                } else {
                    Text(label)
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.top, 4)
                }
            }
        }
        .padding(.horizontal, UIConstants.Geometry.defaultPadding)
        .padding(.vertical, UIConstants.Geometry.defaultPadding)
        .background(type.color)
        .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
    }
}


struct StatsItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatsItemView(type: .domainsOnBlockList, label: "1234")
    }
}
