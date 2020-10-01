//
//  ViewUtils.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 01/10/2020.
//

import SwiftUI

struct ViewUtils {
    
    static func shieldStatusImageForDataProvider(_ dataProvider: PiholeDataProvider) -> some View {
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
