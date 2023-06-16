//
//  CircleBadgeStatus.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 13/07/2020.
//

import SwiftUI

struct CircleBadgeStatus: View {
    let dataProvider: PiholeDataProvider
    private let circleSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: circleSize, height: circleSize)

            ViewUtils.shieldStatusImageForDataProvider(dataProvider)
                .font(.title2)
        }
    }
}

struct CircleBadgeStatus_Previews: PreviewProvider {
    static var previews: some View {
        CircleBadgeStatus(dataProvider: PiholeDataProvider.previewData())
    }
}
