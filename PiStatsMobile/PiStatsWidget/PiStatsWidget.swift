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
}

struct PiholeTimelineProvider: TimelineProvider {
    typealias Entry = PiholeEntry
    private static let fakePihole = PiholeDataProvider.previewData()

    func snapshot(with context: Context, completion: @escaping (PiholeEntry) -> ()) {
        let entry = PiholeEntry(piholeDataProvider: PiholeTimelineProvider.fakePihole, date: Date())
        completion(entry)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<PiholeEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        let piholes = Pihole.restoreAll()
        print("Pihole count \(piholes.count)")
        let provider = PiholeDataProvider(piholes: piholes)
        provider.fetchSummaryData {

            let entry = PiholeEntry(piholeDataProvider: provider, date: Date())
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

struct PiStatsWidgetEntryView : View {
    var entry: PiholeEntry
    
    var body: some View {
        VStack (spacing:0) {
            HStack(spacing:0) {
                ZStack {
                    StatsItemType.totalQueries.color
                    StatsItemView(contentType: .totalQueries, value: entry.piholeDataProvider.totalQueries)
                }
                ZStack {
                    StatsItemType.queriesBlocked.color
                    StatsItemView(contentType: .queriesBlocked, value: entry.piholeDataProvider.queriesBlocked)
                }
            }
            HStack(spacing:0) {
                ZStack {
                    StatsItemType.percentBlocked.color
                    StatsItemView(contentType: .percentBlocked, value: entry.piholeDataProvider.percentBlocked)
                }
                ZStack {
                    StatsItemType.domainsOnBlockList.color
                    StatsItemView(contentType: .domainsOnBlockList, value: entry.piholeDataProvider.domainsOnBlocklist)
                }
            }
        }
    }
}

@main
struct PiStatsWidget: Widget {
    private let kind: String = "PiStatsWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PiholeTimelineProvider(), placeholder: PlaceholderView()) { entry in
            PiStatsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PiStatsWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PiStatsWidgetEntryView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            PiStatsWidgetEntryView(entry: PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            PlaceholderView()
                .previewContext(WidgetPreviewContext(family: .systemSmall))

        }
    }
}
