//
//  PiholeTimelineProvider.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 21/07/2020.
//

import WidgetKit
import Foundation

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
