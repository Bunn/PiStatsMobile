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

#if DEBUG

extension PiholeEntry {
    static let previewSmall = PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemSmall)
    static let previewSmallAlternate = PiholeEntry(piholeDataProvider: PiholeDataProvider.previewDataAlternate(), date: Date(), widgetFamily: .systemSmall)
    static let previewMedium = PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium)
    static let previewMediumAlternate = PiholeEntry(piholeDataProvider: PiholeDataProvider.previewDataAlternate(), date: Date(), widgetFamily: .systemMedium)
}

@available(iOS 17.0, *)
#Preview("Small", as: .systemSmall) {
    ViewStatsWidget()
} timeline: {
    PiholeEntry.previewSmall
    PiholeEntry.previewSmallAlternate
}

@available(iOS 17.0, *)
#Preview("Medium", as: .systemMedium) {
    ViewStatsWidget()
} timeline: {
    PiholeEntry.previewMedium
    PiholeEntry.previewMediumAlternate
}

#endif // DEBUG
