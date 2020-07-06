//
//  UIConstants.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct UIConstants {
    struct Geometry {
        static let defaultCornerRadius: CGFloat = 10.0
        static let defaultPadding: CGFloat = 10.0
        static let shadowRadius: CGFloat = 0
        static let addPiholeButtonHeight: CGFloat = 55.0
    }
    
    struct Colors {
        static let background = Color("BackgroundColor")
        static let cardColor = Color("CardColor")
        static let cardColorGradientTop = Color("CardColorGradientTop")
        static let cardColorGradientBottom = Color("CardColorGradientBottom")
    }
    
    struct Strings {
        static let disableButton = LocalizedStringKey("Disable")
        static let enableButton = "Enable"
        static let totalQueries = LocalizedStringKey("Total Queries")
        static let percentBlocked = LocalizedStringKey("Percent Blocked")
        static let blocklist = LocalizedStringKey("Blocklist")
        static let queriesBlocked = LocalizedStringKey("Queries Blocked")
        static let settings = LocalizedStringKey("Settings")
    }
}
