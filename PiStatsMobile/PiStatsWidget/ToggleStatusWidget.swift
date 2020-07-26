//
//  ToggleStatusWidget.swift
//  ToggleStatusWidget
//
//  Created by Fernando Bunn on 21/07/2020.
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

private struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct ToggleStatusWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
        HStack {
            VStack (alignment: .leading) {
                Button(action: {
                    print("a")
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: UIConstants.Geometry.addPiholeButtonHeight, height: UIConstants.Geometry.addPiholeButtonHeight, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                })

                Spacer()
                VStack (alignment: .leading) {
                    Text("192.168.1.123")
                        .font(.footnote)
                        .bold()
                    Text("Enabled")
                        .font(.caption)
                }
                
            }
            Spacer()
                
            ZStack {
                VStack (spacing:0) {
                    HStack(spacing:0) {
                        SmallStatsItem(itemType: StatsItemType.totalQueries, value: "33 326")
                        SmallStatsItem(itemType: StatsItemType.queriesBlocked, value: "6 223")
                    }
                    HStack(spacing:0) {
                        SmallStatsItem(itemType: StatsItemType.percentBlocked, value: "34.2%")
                        SmallStatsItem(itemType: StatsItemType.domainsOnBlockList, value: "234 432")
                    }
                }
            }
                .frame(width: geometry.size.width / 2)
                .cornerRadius(10.0)
              }
        
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, UIConstants.Geometry.widgetDefaultPadding)
        .background(Color(.secondarySystemGroupedBackground))
    }
}

struct ToggleStatusWidget: Widget {
    private let kind: String = "ToggleStatusWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            ToggleStatusWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pi Stats")
        .description("Display the status of your pi-holes with a button link to enable/disable them.")
    }
}

struct ToggleStatusWidget_Previews: PreviewProvider {
    static var previews: some View {
        ToggleStatusWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
