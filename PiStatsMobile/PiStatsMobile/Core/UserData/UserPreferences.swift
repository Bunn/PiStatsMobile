//
//  Settings.swift
//  PiHoleStats
//
//  Created by Fernando Bunn on 11/05/2020.
//  Copyright © 2020 Fernando Bunn. All rights reserved.
//

import Foundation
import SwiftUI

private enum Keys: String {
    case disablePermanently
    case displayStatsAsList
    case displayStatsIcons
    case displayIconBadgeForOfflinePiholes
}

class UserPreferences: ObservableObject {
    @AppStorage(Keys.disablePermanently.rawValue) var disablePermanently: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(Keys.displayStatsAsList.rawValue) var displayStatsAsList: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(Keys.displayStatsIcons.rawValue) var displayStatsIcons: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }
    @AppStorage(Keys.displayIconBadgeForOfflinePiholes.rawValue) var displayIconBadgeForOfflinePiholes: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }
}
