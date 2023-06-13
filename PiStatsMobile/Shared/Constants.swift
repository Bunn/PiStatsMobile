//
//  Constants.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 02/10/2020.
//

import Foundation

struct Constants {
    static let appGroup: String = {
        /// The PiStatsAppGroupID is included in each bundle's Info.plist with the processed value from the xcconfig file.
        guard let id = Bundle.main.infoDictionary?["PiStatsAppGroupID"] as? String, !id.isEmpty else {
            assertionFailure("Expected Info.plist for \(Bundle.main.bundleURL.lastPathComponent) to include non-empty PiStatsAppGroupID")
            return "group.dev.bunn.PiStatsMobile"
        }
        return id
    }()
}
