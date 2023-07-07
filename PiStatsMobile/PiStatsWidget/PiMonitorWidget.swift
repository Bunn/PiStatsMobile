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
        PiMonitorView(provider: PiholeDataProvider.previewData(), shouldDisplayStats: false )
            .redacted(reason: .placeholder)
    }
}

struct PiMonitorWidget: Widget {
    private let kind: String = "PiMonitorWidget"
    public var body: some WidgetConfiguration {
        let config = IntentConfiguration(
            kind: "dev.bunn.PiStatsMobile.SelectPiholeIntent",
            intent: SelectPiholeIntent.self,
            provider: PiMonitorTimelineProvider()
        ) { entry in
            PiMonitorWidgetView(entry: entry)
        }
        .configurationDisplayName("Pi Monitor")
        .description("Display metrics for your Raspberry Pi")
        .supportedFamilies([.systemSmall, .systemMedium])

        if #available(iOSApplicationExtension 17.0, *) {
            return config.contentMarginsDisabled()
        } else {
            return config
        }
    }
}

#if DEBUG

@available(iOS 17.0, *)
#Preview("Small", as: .systemSmall) {
    PiMonitorWidget()
} timeline: {
    PiholeEntry.previewSmall
    PiholeEntry.previewSmallAlternate
}

@available(iOS 17.0, *)
#Preview("Medium", as: .systemSmall) {
    PiMonitorWidget()
} timeline: {
    PiholeEntry.previewMedium
    PiholeEntry.previewMediumAlternate
}

#endif // DEBUG
