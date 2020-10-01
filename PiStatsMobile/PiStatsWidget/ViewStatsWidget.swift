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
    }
}

struct ViewStatsWidget: Widget {
    private let kind: String = "ViewStatsWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PiholeTimelineProvider()) { entry in
            PiStatsDisplayWidgetView(entry: entry)
        }
        .configurationDisplayName("Pi Stats")
        .description("Display the status of your pi-holes")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


struct ViewStatsWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        PiStatsDisplayWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        PiStatsDisplayWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        PlaceholderView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
    }
}

