//
//  PiMonitorWidgetView.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 29/09/2020.
//

import SwiftUI
import WidgetKit

struct PiMonitorWidgetView: View {
    var entry: PiholeEntry
    var shouldDisplayStats: Bool {
        entry.widgetFamily == .systemMedium
    }
    
    var body: some View {
        ZStack {
            UIConstants.Colors.piMonitorWidgetBackground
            
            if entry.piholeDataProvider.piholes.count == 0 {
                PiMonitorView(provider: PiholeDataProvider.previewData() , shouldDisplayStats: shouldDisplayStats).redacted(reason: .placeholder)
            } else if entry.piholeDataProvider.canDisplayMetrics == false {
                VStack (spacing: 10) {
                    Image(systemName: UIConstants.SystemImages.piholeSetupMonitor)
                        .foregroundColor(UIConstants.Colors.domainsOnBlocklist)

                    Text("\(UIConstants.Strings.Widget.piholeNotEnabledOn) \(entry.piholeDataProvider.name)")
                        .multilineTextAlignment(.center)
                }
                .font(Font.headline.weight(.semibold))
                .padding()
            }
            else {
                PiMonitorView(provider: entry.piholeDataProvider, shouldDisplayStats: shouldDisplayStats)
            }
        }
    }
}

struct PiMonitorWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PiMonitorWidgetView(entry: PiholeEntry.init(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        PiMonitorWidgetView(entry: PiholeEntry.init(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
