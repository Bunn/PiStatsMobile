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
        static let widgetDefaultPadding: CGFloat = 16.0
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
        static let statusOffline = Color("StatusOffline")
        static let statusOnline = Color("StatusOnline")
        static let statusWarning = Color("StatusWarning")
        static let errorMessage = Color("StatusOffline")
        static let piMonitorWidgetBackground = Color("PiMonitorWidgetBackground")
    }
    
    struct Strings {
        static let disableButton = "Disable"
        static let enableButton = "Enable"
        static let totalQueries = "Total Queries"
        static let percentBlocked = "Percent Blocked"
        static let blocklist = "Blocklist"
        static let queriesBlocked = "Queries Blocked"
        static let piholeTokenFooterSection = "Token is required for some functionalities like disable/enable your pi-hole.\n\nYou can find the API Token on /etc/pihole/setupVars.conf under WEBPASSWORD or you can open the web UI and go to Settings -> API -> Show API Token"
        static let piholeSetupHostPlaceholder = "Host"
        static let piholeSetupPortPlaceholder = "Port (80)"
        static let piholeSetupDisplayName = "Display Name (Optional)"
        static let piMonitorSetupPortPlaceholder = "Port (8088)"
        static let piholeSetupTokenPlaceholder = "Token (Optional)"
        static let piholeSetupEnablePiMonitor = "Enable Pi Monitor"
        static let piMonitorSetupAlertTitle = "Pi Monitor"
        static let piMonitorSetupAlertOKButton = "OK"
        static let piMonitorSetupAlertLearnMoreButton = "Learn More"
        static let saveButton = "Save"
        static let cancelButton = "Cancel"
        static let deleteButton = "Delete"
        static let statusEnabled = "Active"
        static let statusDisabled = "Offline"
        static let statusNeedsAttention = "Needs Attention"
        static let statusEnabledAndDisabled = "Partially Active"
        static let piMonitorExplanation = "Pi Monitor is a service that helps you to monitor your Raspberry Pi by showing you information like temperature, memory usage and more!\n\nIn order to use it you'll need to install it in your Raspberry Pi."

        static let addFirstPiholeCaption = "Tap here to add your first pi-hole"
        static let displayIconBadgeForOfflinePiholes = "Display icon badge for offline pi-holes"
        static let piholesNavigationTitle = "Pi-holes"
        static let settingsNavigationTitle = "Settings"
        static let disablePiholeOptionsTitle = "Disable Pi-hole"
        static let disablePiholeOptionsPermanently = "Permanently"
        static let settingsSectionPihole = "Pi-hole"
        static let settingsSectionPiMonitor = "Pi Monitor"
        static let qrCodeScannerTitle = "Scanner"
        static let piholeSetupTitle = "Pi-hole Setup"
        static let allPiholesTitle = "All Pi-holes"
        static let temperatureScaleCelsius = "°C"
        static let temperatureScaleFahrenheit = "°F"
        
        struct Widget {
            static let piholeNotEnabledOn = "Pi Monitor is not enabled on"
        }

        struct Preferences {
            static let sectionInterface = "Interface"
            static let sectionEnableDisable = "Enable / Disable"
            static let sectionPiMonitor = "Pi Monitor"
            static let about = "About"
            static let displayAsList = "Display Pi-hole stats as list"
            static let displayIcons = "Display Pi-hole stats icons"
            static let alwaysDisablePermanently = "Always disable Pi-hole permanently"
            static let displayAllPiholesInSingleCard = "Display all Pi-holes in a single card"
            static let version = "Version"
            static let piStatsSourceCode = "Pi Stats source code"
            static let piStatsForMacOS = "Pi Stats for macOS"
            static let leaveReview = "Write a review on the App Store"
            static let customizeDisableTimes = "Customize disable times"
            static let piMonitorTemperature = "Temperature Scale"
        }

        struct CustomizeDisabletime {
            static let emptyListMessage = "Tap here to add a custom disable time"
            static let title = "Disable Time"
        }
        
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
        static let piholeSetupDisplayName = "person.crop.square.fill.and.at.rectangle"
        static let piholeSetupPort = "globe"
        static let piholeSetupToken = "key"
        static let piholeSetupTokenQRCode = "qrcode"
        static let piholeStatusWarning = "exclamationmark.shield.fill"
        static let piholeStatusOffline = "xmark.shield.fill"
        static let piholeStatusOnline = "checkmark.shield.fill"
        static let errorMessageWarning = "exclamationmark.triangle.fill"
        static let settingsDisablePermanently = "xmark.shield"
        static let settingsDisplayAllPiholesInSingleCard = "square.split.2x2"
        static let settingsDisplayIcons = "globe"
        static let settingsDisplayAsList = "list.bullet"
        static let settingsDisplayIconBadgeForOffline = "app.badge"
        static let addPiholeButton = "plus"
        static let disablePiholeButton = "stop.fill"
        static let enablePiholeButton = "play.fill"
        static let metricTemperature = "thermometer"
        static let metricUptime = "power"
        static let metricLoadAverage = "cpu"
        static let metricMemoryUsage = "memorychip"
        static let piholeSetupMonitor = "binoculars"
        static let piMonitorInfoButton = "info.circle"
        static let deleteButton = "minus.circle.fill"
        static let piStatsSourceCode = "terminal"
        static let piStatsMacOS = "desktopcomputer"
        static let leaveReview = "heart"
        static let customizeDisableTimes = "clock"
        static let addNewCustomDisableTime = "plus"
        static let piMonitorTemperature = "thermometer"

    }
}
