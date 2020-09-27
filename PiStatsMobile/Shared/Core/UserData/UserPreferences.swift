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
    case displayAllPiholes
    case displayIconBadgeForOfflinePiholes
    case disableTimes
}

class UserPreferences: ObservableObject {
    static let shared = UserPreferences()

    @AppStorage(Keys.displayAllPiholes.rawValue) var displayAllPiholes: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
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
    
    @Published var disableTimes: [TimeInterval] = UserDefaults.standard.object(forKey: Keys.disableTimes.rawValue) as? [TimeInterval] ?? [30, 60, 300] {
        didSet {
            UserDefaults.standard.set(disableTimes, forKey: Keys.disableTimes.rawValue)
        }
    }
    
    /*
     TODO: Improve this:
     I'm not sure how to have an AppStorage + Published, so I used standard UserDefaults
     Also, the handling of the requestAuthorization and badge reset should be done by the caller since this
     class should only be responsible for data storage and not business logic
     */
    @Published var displayIconBadgeForOfflinePiholes: Bool =  UserDefaults.standard.object(forKey: Keys.displayIconBadgeForOfflinePiholes.rawValue) as? Bool ?? false {
        willSet {
            if newValue {
                UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
                    if granted == false {
                        DispatchQueue.main.async {
                            self.displayIconBadgeForOfflinePiholes = false
                        }
                    }
                }
            } else {
               // UIApplication.shared.applicationIconBadgeNumber = 0
            }
        } didSet {
            UserDefaults.standard.set(displayIconBadgeForOfflinePiholes, forKey: Keys.displayIconBadgeForOfflinePiholes.rawValue)
        }
    }
}
