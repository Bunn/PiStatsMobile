//
//  PiMonitorStatusHeader.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 01/10/2020.
//

import SwiftUI

struct PiMonitorStatusHeader: View {
    var provider: PiholeDataProvider
    
    var body: some View {
        VStack (alignment:.leading) {
            Label(title: {
                Text(provider.name)
            }, icon: {
                ViewUtils.shieldStatusImageForDataProvider(provider)
            })
            .font(Font.headline.weight(.bold))
            Divider()
            Spacer()
        }
    }
}

struct PiMonitorStatusHeader_Previews: PreviewProvider {
    static var previews: some View {
        PiMonitorStatusHeader(provider: PiholeDataProvider.previewData())
    }
}
