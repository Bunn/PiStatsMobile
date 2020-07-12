//
//  UserDefaultExtensions.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 12/07/2020.
//

import Foundation

extension UserDefaults {
  
    static func shared() -> UserDefaults {
        let appGroup = "group.dev.bunn.PiStatsMobile"
        return UserDefaults(suiteName: appGroup)!
    }
}
