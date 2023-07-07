//
//  PiStatsDisplayWidgetView.swift
//  PiStatsWidgetExtension
//
//  Created by Fernando Bunn on 13/07/2020.
//

import SwiftUI
import WidgetKit

struct PiStatsDisplayWidgetView : View {
    var entry: PiholeEntry
    
    var body: some View {
        ZStack {
            if entry.widgetFamily == WidgetFamily.systemSmall {
                ZStack {
                    VStack (spacing:0) {
                        HStack(spacing:0) {
                            SmallStatsItem(itemType: StatsItemType.totalQueries, value: entry.piholeDataProvider.totalQueries)
                            SmallStatsItem(itemType: StatsItemType.queriesBlocked, value: entry.piholeDataProvider.queriesBlocked)
                        }
                        HStack(spacing:0) {
                            SmallStatsItem(itemType: StatsItemType.percentBlocked, value: entry.piholeDataProvider.percentBlocked)
                            SmallStatsItem(itemType: StatsItemType.domainsOnBlockList, value: entry.piholeDataProvider.domainsOnBlocklist)
                        }
                    }
                    circleBadge
                }
            } else {
                ZStack {
                    VStack (alignment:.leading, spacing:0) {
                        HStack(spacing:0) {
                            MediumStatsItem(contentType: .totalQueries, value: entry.piholeDataProvider.totalQueries)
                            MediumStatsItem(contentType: .queriesBlocked, value: entry.piholeDataProvider.queriesBlocked)
                        }
                        HStack(spacing:0) {
                            MediumStatsItem(contentType: .percentBlocked, value: entry.piholeDataProvider.percentBlocked)
                            MediumStatsItem(contentType: .domainsOnBlockList, value: entry.piholeDataProvider.domainsOnBlocklist)
                        }
                    }
                    circleBadge
                }
            }
        }
        .widgetBackground()
    }

    @ViewBuilder
    private var circleBadge: some View {
        if #available(iOS 17.0, *) {
            Button(intent: RefreshWidgetIntent()) {
                CircleBadgeStatus(dataProvider: entry.piholeDataProvider)
            }
            .buttonStyle(.borderless)
        } else {
            CircleBadgeStatus(dataProvider: entry.piholeDataProvider)
        }
    }
}
