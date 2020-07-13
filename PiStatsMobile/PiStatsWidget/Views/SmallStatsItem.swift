//
//  SmallStatsItem.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 13/07/2020.
//

import SwiftUI

struct SmallStatsItem: View {
    let itemType: StatsItemType
    let value: String
    private let stackSpacing: CGFloat = 10
    
    var body: some View {
        ZStack {
            itemType.color
            VStack(spacing: stackSpacing) {
                Image(systemName: itemType.imageName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(value)
                    .foregroundColor(.white)
                    .font(.body)
            }
        }
    }
}

struct SmallStatsItem_Previews: PreviewProvider {
    static var previews: some View {
        SmallStatsItem(itemType: .domainsOnBlockList, value: "1234")
    }
}
