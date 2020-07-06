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
        static let piholeTokenFooterSection = LocalizedStringKey("Token is required for some functionalities like disable/enable your pi-hole.\n\nYou can find the API Token on /etc/pihole/setupVars.conf under WEBPASSWORD or you can open the web UI and go to Settings -> API -> Show API Token")
        static let piholeSetupHostPlaceholder = LocalizedStringKey("Host")
        static let piholeSetupPortPlaceholder = LocalizedStringKey("Port (Optional)")
        static let piholeSetupTokenPlaceholder = LocalizedStringKey("Token (Optional)")
        static let saveButton = LocalizedStringKey("Save")
        static let cancelButton = LocalizedStringKey("Cancel")
    }
    
    struct SystemImages {
        static let piholeSetupHost = "server.rack"
        static let piholeSetupPort = "globe"
        static let piholeSetupToken = "key"
        static let piholeSetupTokenQRCode = "qrcode"

    }
}
