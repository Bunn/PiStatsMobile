//
//  PiMonitorTimelineProvider.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 30/09/2020.
//


import WidgetKit
import Foundation
import os.log

struct PiMonitorTimelineProvider: IntentTimelineProvider {
    typealias Intent = SelectPiholeIntent
    
    typealias Entry = PiholeEntry
    private static let fakePihole = PiholeDataProvider.previewData()
    private let log = Logger().osLog(describing: PiMonitorTimelineProvider.self)

    func placeholder(in context: Context) -> PiholeEntry {
        PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemSmall)
    }
    
    func getSnapshot(for configuration: Intent, in context: Context, completion: @escaping (PiholeEntry) -> Void) {
        let entry = PiholeEntry(piholeDataProvider: PiMonitorTimelineProvider.fakePihole, date: Date(), widgetFamily: context.family)
        completion(entry)
    }

    
    func getTimeline(for configuration: SelectPiholeIntent, in context: Context, completion: @escaping (Timeline<PiholeEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!

        if let identifier = configuration.pihole?.identifier,
           let piholeUUID = UUID(uuidString: identifier),
           let pihole = Pihole.restore(piholeUUID) {
            let provider = PiholeDataProvider(piholes: [pihole])
            os_log("get timeline called")
            
            provider.fetchSummaryData {
                os_log("summary returned")
                provider.fetchMetricsData {
                    os_log("metrics returned")
                    let entry = PiholeEntry(piholeDataProvider: provider, date: Date(), widgetFamily: context.family)
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            }
          
        } else {
            os_log("No pihole found/selected")
            let provider = PiholeDataProvider(piholes: [])
            let entry = PiholeEntry(piholeDataProvider: provider, date: Date(), widgetFamily: context.family)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}
