//
//  UIConstants.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

struct UIConstants {
    struct Geometry {
        static let defaultCornerRadius: CGFloat = 15.0
        static let defaultPadding: CGFloat = 10.0
        static let shadowRadius: CGFloat = 3.0
    }
    
    struct Colors {
        static let background = Color("BackgroundColor")
        static let cardColor = Color("CardColor")
        static let cardColorGradientTop = Color("CardColorGradientTop")
        static let cardColorGradientBottom = Color("CardColorGradientBottom")
    }
    
    struct Strings {
        static let disableButton = NSLocalizedString("Disable", comment: "Pi-hole disable button")
        static let enableButton = NSLocalizedString("Enable", comment: "Pi-hole enable button")
    }
}
