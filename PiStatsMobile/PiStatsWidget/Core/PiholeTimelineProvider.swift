//
//  PiholeTimelineProvider.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 21/07/2020.
//

import WidgetKit
import Foundation
import os.log

struct PiholeTimelineProvider: TimelineProvider {
    typealias Entry = PiholeEntry
    private static let fakePihole = PiholeDataProvider.previewData()
    private let log = Logger().osLog(describing: PiholeTimelineProvider.self)

    func placeholder(in context: Context) -> PiholeEntry {
        PiholeEntry(piholeDataProvider: PiholeDataProvider.previewData(), date: Date(), widgetFamily: .systemSmall)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PiholeEntry) -> Void) {
        let entry = PiholeEntry(piholeDataProvider: PiholeTimelineProvider.fakePihole, date: Date(), widgetFamily: context.family)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PiholeEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        let piholes = Pihole.restoreAll()
        let provider = PiholeDataProvider(piholes: piholes)
        os_log("get timeline called")
    
        provider.fetchSummaryData {
            os_log("summary returned")
            
            let entry = PiholeEntry(piholeDataProvider: provider, date: Date(), widgetFamily: context.family)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}
