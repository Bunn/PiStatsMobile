//
//  PiholeEntry.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 21/07/2020.
//

import WidgetKit
import Foundation

struct PiholeEntry: TimelineEntry {
    let piholeDataProvider: PiholeDataProvider
    let date: Date
    let widgetFamily: WidgetFamily
}
