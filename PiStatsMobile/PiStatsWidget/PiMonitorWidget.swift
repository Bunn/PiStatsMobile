//
//  PiMonitorWidget.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 29/09/2020.
//

import WidgetKit
import SwiftUI

private struct PlaceholderView : View {
    var body: some View {
        PiMonitorView(provider: PiholeDataProvider.previewData() ).redacted(reason: .placeholder)
    }
}

struct PiMonitorWidget: Widget {
    private let kind: String = "PiMonitorWidget"
    public var body: some WidgetConfiguration {
        
        IntentConfiguration(
            kind: "dev.bunn.PiStatsMobile.SelectPiholeIntent",
            intent: SelectPiholeIntent.self,
            provider: PiMonitorTimelineProvider()
        ) { entry in
            PiMonitorWidgetView(entry: entry)
        }
        .configurationDisplayName("Pi Monitor")
        .description("Display metrics for your Raspberry Pi")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


struct PiMonitorWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        PiMonitorWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        PiMonitorWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        PlaceholderView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

