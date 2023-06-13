//
//  PiStatsWidget.swift
//  PiStatsWidget
//
//  Created by Fernando Bunn on 11/07/2020.
//

import WidgetKit
import SwiftUI

private struct PlaceholderView : View {
    var body: some View {
        VStack (spacing:0) {
            HStack(spacing:0) {
                StatsItemType.totalQueries.color
                StatsItemType.queriesBlocked.color
            }
            HStack(spacing:0) {
                StatsItemType.percentBlocked.color
                StatsItemType.domainsOnBlockList.color
            }
        }
        .widgetBackground()
    }
}

struct ViewStatsWidget: Widget {
    private let kind: String = "ViewStatsWidget"
    
    public var body: some WidgetConfiguration {
        let config = StaticConfiguration(kind: kind, provider: PiholeTimelineProvider()) { entry in
            PiStatsDisplayWidgetView(entry: entry)
        }
        .configurationDisplayName("Pi Stats")
        .description("Display the status of your pi-holes")
        .supportedFamilies([.systemSmall, .systemMedium])

        if #available(iOSApplicationExtension 17.0, *) {
            return config.contentMarginsDisabled()
        } else {
            return config
        }
    }
}

struct ViewStatsWidget_Previews: PreviewProvider {
    /// NOTE: Previews do not respect `contentMarginsDisabled` from widget because they use the view directly,
    /// so margins will not look correct in Xcode Previews.
    static var previews: some View {
        PiStatsDisplayWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("System Small")

        PiStatsDisplayWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("System Medium")

        PlaceholderView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Placeholder")
    }
}

