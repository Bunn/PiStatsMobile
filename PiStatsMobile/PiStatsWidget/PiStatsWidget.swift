//
//  PiStatsWidget.swift
//  PiStatsWidget
//
//  Created by Fernando Bunn on 11/07/2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry

    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct PiStatsWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack (spacing:0) {
            HStack(spacing:0) {
                ZStack {
                    StatsItemType.totalQueries.color
                    StatsItemView(contentType: .totalQueries, value: "123")
                }
                ZStack {
                    StatsItemType.queriesBlocked.color
                    StatsItemView(contentType: .queriesBlocked, value: "123")
                }
            }
            HStack(spacing:0) {
                ZStack {
                    StatsItemType.percentBlocked.color
                    StatsItemView(contentType: .percentBlocked, value: "123")
                }
                ZStack {
                    StatsItemType.domainsOnBlockList.color
                    StatsItemView(contentType: .domainsOnBlockList, value: "123")
                }
            }
        }
    }
}

@main
struct PiStatsWidget: Widget {
    private let kind: String = "PiStatsWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            PiStatsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PiStatsWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PiStatsWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            PiStatsWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
        }
    }
}
