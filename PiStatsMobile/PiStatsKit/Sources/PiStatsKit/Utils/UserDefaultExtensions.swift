//
//  UserDefaultExtensions.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 12/07/2020.
//

import Foundation

public extension UserDefaults {
    static func shared() -> UserDefaults {
        return UserDefaults(suiteName: Constants.appGroup)!
    }
}
