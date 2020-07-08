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
        static let domainsOnBlocklist = Color("DomainsOnBlockList")
        static let totalQueries = Color("TotalQueries")
        static let queriesBlocked = Color("QueriesBlocked")
        static let percentBlocked = Color("PercentBlocked")
        static let disabled = Color("Disabled")
        static let enabled = Color("Enabled")
        static let enabledAndDisabled = Color("EnabledAndDisabled")

    }
    
    struct Strings {
        static let disableButton = "Disable"
        static let enableButton = "Enable"
        static let totalQueries = "Total Queries"
        static let percentBlocked = "Percent Blocked"
        static let blocklist = "Blocklist"
        static let queriesBlocked = "Queries Blocked"
        static let settings = "Settings"
        static let piholeTokenFooterSection = "Token is required for some functionalities like disable/enable your pi-hole.\n\nYou can find the API Token on /etc/pihole/setupVars.conf under WEBPASSWORD or you can open the web UI and go to Settings -> API -> Show API Token"
        static let piholeSetupHostPlaceholder = "Host"
        static let piholeSetupPortPlaceholder = "Port (Optional)"
        static let piholeSetupTokenPlaceholder = "Token (Optional)"
        static let saveButton = "Save"
        static let cancelButton = "Cancel"
        static let statusEnabled = "Active"
        static let statusDisabled = "Offline"
        static let statusNeedsAttention = "Needs Attention"
        static let statusEnabledAndDisabled = "Partially Active"

        struct Error {
            static let invalidAPIToken = "Invalid API Token"
            static let invalidResponse = "Invalid Response"
            static let invalidURL = "Invalid URL"
            static let decodeResponseError = "Can't decode response"
            static let noAPITokenProvided = "No API Token Provided"
            static let sessionError = "Session Error"
        }

    }
    
    struct SystemImages {
        static let piholeSetupHost = "server.rack"
        static let piholeSetupPort = "globe"
        static let piholeSetupToken = "key"
        static let piholeSetupTokenQRCode = "qrcode"

    }
}
