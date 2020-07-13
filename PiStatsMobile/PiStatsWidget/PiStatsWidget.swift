//
//  PiStatsWidget.swift
//  PiStatsWidget
//
//  Created by Fernando Bunn on 11/07/2020.
//

import WidgetKit
import SwiftUI

struct PiholeEntry: TimelineEntry {
    let piholeDataProvider: PiholeDataProvider
    let date: Date
    let widgetFamily: WidgetFamily
}

struct PiholeTimelineProvider: TimelineProvider {
    typealias Entry = PiholeEntry
    private static let fakePihole = PiholeDataProvider.previewData()
    
    func snapshot(with context: Context, completion: @escaping (PiholeEntry) -> ()) {
        let entry = PiholeEntry(piholeDataProvider: PiholeTimelineProvider.fakePihole, date: Date(), widgetFamily: context.family)
        completion(entry)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<PiholeEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        let piholes = Pihole.restoreAll()
        let provider = PiholeDataProvider(piholes: piholes)
        provider.fetchSummaryData {
            
            let entry = PiholeEntry(piholeDataProvider: provider, date: Date(), widgetFamily: context.family)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct PlaceholderView : View {
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


@main
struct PiStatsWidget: Widget {
    private let kind: String = "Pi Stats Widget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PiholeTimelineProvider(), placeholder: PlaceholderView()) { entry in
            PiStatsDisplayWidgetView(entry: entry)
        }
        .configurationDisplayName("Pi Stats")
        .description("Display the status of your pi-holes")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PiStatsWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        PiStatsDisplayWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemSmall))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        PiStatsDisplayWidgetView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemMedium))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        PlaceholderView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
    }
}

