//
//  StatsItemType.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

enum StatsItemType {
    case totalQueries
    case queriesBlocked
    case percentBlocked
    case domainsOnBlockList

    var imageName: String {
        switch self {
        case .domainsOnBlockList:
            return "list.bullet"
        case .totalQueries:
            return "globe"
        case .queriesBlocked:
            return "hand.raised"
        case .percentBlocked:
            return "chart.pie"
        }
    }
    
    var title: String {
        switch self {
        case .domainsOnBlockList:
            return "Blocklist"
        case .totalQueries:
            return "Total Queries"
        case .queriesBlocked:
            return "Queries Blocked"
        case .percentBlocked:
            return "Percent Blocked"
        }
    }
    
    var colorName: String {
        switch self {
        case .domainsOnBlockList:
            return "DomainsOnBlockList"
        case .totalQueries:
            return "TotalQueries"
        case .queriesBlocked:
            return "QueriesBlocked"
        case .percentBlocked:
            return "PercentBlocked"
        }
    }
}
