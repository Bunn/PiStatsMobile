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
    case disableTimes
    case temperatureScale
}

enum TemperatureScale {
    case celsius
    case fahrenheit
}

class UserPreferences: ObservableObject {
    static let shared = UserPreferences()
    var temperatureScaleType: TemperatureScale {
        get {
            if temperatureScale == 1 {
                return .fahrenheit
            }
            return .celsius
        }
    }
    
    init() {
        migrateStandardUserDefaultToGroupIfNecessary()
    }
    
    private func migrateStandardUserDefaultToGroupIfNecessary() {
        let keys = [
            Keys.displayAllPiholes.rawValue,
            Keys.disablePermanently.rawValue,
            Keys.displayStatsAsList.rawValue,
            Keys.displayStatsIcons.rawValue,
            Keys.temperatureScale.rawValue,
            Keys.disableTimes.rawValue
        ]
        
        keys.forEach { key in
            if let value = UserDefaults.standard.object(forKey: key) {
                UserDefaults.standard.removeObject(forKey: key)
                /*
                 If I only set the disableTimes using the shared().setValue, it's getter returns nil and then returns the default set of intervals.
               */
                if key == Keys.disableTimes.rawValue {
                    if let times = value as? [TimeInterval] {
                        disableTimes = times
                    }
                } else {
                    UserDefaults.shared().setValue(value, forKey: key)
                }
            }
        }

        UserDefaults.shared().synchronize()
    }

    @AppStorage(Keys.displayAllPiholes.rawValue, store: UserDefaults(suiteName: Constants.appGroup)) var displayAllPiholes: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(Keys.disablePermanently.rawValue, store: UserDefaults(suiteName: Constants.appGroup)) var disablePermanently: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(Keys.displayStatsAsList.rawValue, store: UserDefaults(suiteName: Constants.appGroup)) var displayStatsAsList: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage(Keys.displayStatsIcons.rawValue, store: UserDefaults(suiteName: Constants.appGroup)) var displayStatsIcons: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var disableTimes: [TimeInterval] = UserDefaults.shared().object(forKey: Keys.disableTimes.rawValue) as? [TimeInterval] ?? [30, 60, 300] {
        didSet {
            UserDefaults.shared().set(disableTimes, forKey: Keys.disableTimes.rawValue)
        }
    }
    
    @AppStorage(Keys.temperatureScale.rawValue, store: UserDefaults(suiteName: Constants.appGroup)) var temperatureScale: Int = 0 {
        willSet {
            objectWillChange.send()
        }
    }
}
