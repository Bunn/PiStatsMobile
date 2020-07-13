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
        Circle()
            .foregroundColor(.white)
            .frame(width: circleSize, height: circleSize)
        
        imageForDataProvider(dataProvider)
            .font(.title2)
    }
    
    func imageForDataProvider(_ dataProvider: PiholeDataProvider) -> some View {
        if dataProvider.hasErrorMessages {
            return Image(systemName: UIConstants.SystemImages.piholeStatusWarning)
                .foregroundColor(UIConstants.Colors.statusWarning)
        } else if dataProvider.status == .allEnabled {
            return Image(systemName: UIConstants.SystemImages.piholeStatusOnline)
                .foregroundColor(UIConstants.Colors.statusOnline)
        } else {
            return Image(systemName: UIConstants.SystemImages.piholeStatusOffline)
                .foregroundColor(UIConstants.Colors.statusOffline)
        }
    }
}

struct CircleBadgeStatus_Previews: PreviewProvider {
    static var previews: some View {
        CircleBadgeStatus(dataProvider: PiholeDataProvider.previewData())
    }
}
