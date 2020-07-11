//
//  StatsItemView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct StatsItemView: View {
    @EnvironmentObject private var userPreferences: UserPreferences
    enum StatsItemViewLayoutType {
        case list
        case rounded
    }
    
    let layoutType: StatsItemViewLayoutType
    let contentType: StatsItemType
    let value: String
    
    var body: some View {
        if layoutType == .list {
            ListStatView(displayStatsIcons: userPreferences.displayStatsIcons, contentType: contentType, value: value)
        } else {
            RoundedStatView(displayStatsIcons: userPreferences.displayStatsIcons, contentType: contentType, label: value)
        }
    }
}

fileprivate struct ListStatView: View {
    let displayStatsIcons: Bool
    let contentType: StatsItemType
    let value: String
    
    var body: some View {
        HStack {
            Label {
                Text(contentType.title)
                    .foregroundColor(.primary)
                    .font(.subheadline)
            } icon: {
                Group {
                    if displayStatsIcons {
                        Image(systemName: contentType.imageName)
                    } else {
                        Image(systemName: "circle.fill")
                    }
                }
                .foregroundColor(contentType.color)
                .font(.subheadline)
                
            }
            Spacer()
            Text(value)
        }
    }
}


fileprivate struct RoundedStatView: View {
    let displayStatsIcons: Bool
    let contentType: StatsItemType
    let label: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(contentType.title)
                .foregroundColor(.white)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                if displayStatsIcons {
                    Label(label, systemImage: contentType.imageName)
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
        .background(contentType.color)
        .cornerRadius(UIConstants.Geometry.defaultCornerRadius)
    }
}


struct StatsItemView_Previews: PreviewProvider {
    static var previews: some View {
        StatsItemView(layoutType: .list, contentType: .domainsOnBlockList, value: "1234")
    }
}
