//
//  MediumStatsItem.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 13/07/2020.
//

import SwiftUI

struct MediumStatsItem: View {
    let contentType: StatsItemType
    let value: String
    private let stackSpacing: CGFloat = 10

    var body: some View {
        ZStack {
            contentType.color
            
            VStack (alignment: .leading, spacing: stackSpacing) {
                Text(contentType.title)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Label(value, systemImage: contentType.imageName)
                        .foregroundColor(.white)
                        .font(.headline)
                        .numericContentTransition()
                }
            }
            .padding(.horizontal, UIConstants.Geometry.widgetDefaultPadding)
            .padding(.vertical, UIConstants.Geometry.widgetDefaultPadding)
        }
    }
}

struct MediumStatsItem_Previews: PreviewProvider {
    static var previews: some View {
        MediumStatsItem(contentType: .domainsOnBlockList, value: "1234")
    }
}
