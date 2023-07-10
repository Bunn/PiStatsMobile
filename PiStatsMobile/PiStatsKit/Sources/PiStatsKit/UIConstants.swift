//
//  UIConstants.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 04/07/2020.
//

import SwiftUI

public struct UIConstants {
    public struct Geometry {
        public static let defaultCornerRadius: CGFloat = 10.0
        public static let defaultPadding: CGFloat = 10.0
        public static let shadowRadius: CGFloat = 0
        public static let addPiholeButtonHeight: CGFloat = 55.0
        public static let widgetDefaultPadding: CGFloat = 16.0
    }
    
    public struct Colors {
        public static let background = Color("BackgroundColor")
        public static let cardColor = Color("CardColor")
        public static let cardColorGradientTop = Color("CardColorGradientTop")
        public static let cardColorGradientBottom = Color("CardColorGradientBottom")
        public static let domainsOnBlocklist = Color("DomainsOnBlockList")
        public static let totalQueries = Color("TotalQueries")
        public static let queriesBlocked = Color("QueriesBlocked")
        public static let percentBlocked = Color("PercentBlocked")
        public static let statusOffline = Color("StatusOffline")
        public static let statusOnline = Color("StatusOnline")
        public static let statusWarning = Color("StatusWarning")
        public static let errorMessage = Color("StatusOffline")
        public static let piMonitorWidgetBackground = Color("PiMonitorWidgetBackground")
    }
    
    public struct Strings {
        public static let disableButton = "Disable"
        public static let enableButton = "Enable"
        public static let totalQueries = "Total Queries"
        public static let percentBlocked = "Percent Blocked"
        public static let blocklist = "Blocklist"
        public static let queriesBlocked = "Queries Blocked"
        public static let piholeTokenFooterSection = "Token is required for some functionalities like disable/enable your pi-hole.\n\nYou can find the API Token on /etc/pihole/setupVars.conf under WEBPASSWORD or you can open the web UI and go to Settings -> API -> Show API Token"
        public static let piholeSetupHostPlaceholder = "Host"
        public static let piholeSetupPortPlaceholder = "Port (80)"
        public static let piholeSetupDisplayName = "Display Name (Optional)"
        public static let piMonitorSetupPortPlaceholder = "Port (8088)"
        public static let piholeSetupTokenPlaceholder = "Token (Optional)"
        public static let piholeSetupEnablePiMonitor = "Enable Pi Monitor"
        public static let piMonitorSetupAlertTitle = "Pi Monitor"
        public static let piMonitorSetupAlertOKButton = "OK"
        public static let piMonitorSetupAlertLearnMoreButton = "Learn More"
        public static let saveButton = "Save"
        public static let cancelButton = "Cancel"
        public static let deleteButton = "Delete"
        public static let statusEnabled = "Active"
        public static let statusDisabled = "Offline"
        public static let statusNeedsAttention = "Needs Attention"
        public static let statusEnabledAndDisabled = "Partially Active"
        public static let piMonitorExplanation = "Pi Monitor is a service that helps you to monitor your Raspberry Pi by showing you information like temperature, memory usage and more!\n\nIn order to use it you'll need to install it in your Raspberry Pi."

        public static let addFirstPiholeCaption = "Tap here to add your first pi-hole"
        public static let piholesNavigationTitle = "Pi-holes"
        public static let settingsNavigationTitle = "Settings"
        public static let disablePiholeOptionsTitle = "Disable Pi-hole"
        public static let disablePiholeOptionsPermanently = "Permanently"
        public static let settingsSectionPihole = "Pi-hole"
        public static let settingsSectionPiMonitor = "Pi Monitor"
        public static let qrCodeScannerTitle = "Scanner"
        public static let piholeSetupTitle = "Pi-hole Setup"
        public static let allPiholesTitle = "All Pi-holes"
        public static let temperatureScaleCelsius = "°C"
        public static let temperatureScaleFahrenheit = "°F"

        public struct Widget {
            public static let piholeNotEnabledOn = "Pi Monitor is not enabled on"
        }

        public struct Preferences {
            public static let sectionInterface = "Interface"
            public static let sectionEnableDisable = "Enable / Disable"
            public static let sectionPiMonitor = "Pi Monitor"
            public static let about = "About"
            public static let displayAsList = "Display Pi-hole stats as list"
            public static let displayIcons = "Display Pi-hole stats icons"
            public static let alwaysDisablePermanently = "Always disable Pi-hole permanently"
            public static let displayAllPiholesInSingleCard = "Display all Pi-holes in a single card"
            public static let version = "Version"
            public static let piStatsSourceCode = "Pi Stats source code"
            public static let piStatsForMacOS = "Pi Stats for macOS"
            public static let leaveReview = "Write a review on the App Store"
            public static let customizeDisableTimes = "Customize disable times"
            public static let piMonitorTemperature = "Temperature Scale"
            public static let protocolHTTP = "HTTP"
            public static let protocolHTTPS = "HTTPS"
        }

        public struct CustomizeDisabletime {
            public static let emptyListMessage = "Tap here to add a custom disable time"
            public static let title = "Disable Time"
        }
        
        public struct Error {
            public static let invalidAPIToken = "Invalid API Token"
            public static let invalidResponse = "Invalid Response"
            public static let invalidURL = "Invalid URL"
            public static let decodeResponseError = "Can't decode response"
            public static let noAPITokenProvided = "No API Token Provided"
            public static let sessionError = "Session Error"
            public static let cantAddNewItem = "Can't add new item"
        }
    }
    
    public struct SystemImages {
        public static let piholeSetupHost = "server.rack"
        public static let piholeSetupDisplayName = "person.crop.square.fill.and.at.rectangle"
        public static let piholeSetupPort = "globe"
        public static let piholeSetupToken = "key"
        public static let piholeSetupTokenQRCode = "qrcode"
        public static let piholeStatusWarning = "exclamationmark.shield.fill"
        public static let piholeStatusOffline = "xmark.shield.fill"
        public static let piholeStatusOnline = "checkmark.shield.fill"
        public static let errorMessageWarning = "exclamationmark.triangle.fill"
        public static let settingsDisablePermanently = "xmark.shield"
        public static let settingsDisplayAllPiholesInSingleCard = "square.split.2x2"
        public static let settingsDisplayIcons = "globe"
        public static let settingsDisplayAsList = "list.bullet"
        public static let settingsDisplayIconBadgeForOffline = "app.badge"
        public static let addPiholeButton = "plus"
        public static let disablePiholeButton = "stop.fill"
        public static let enablePiholeButton = "play.fill"
        public static let metricTemperature = "thermometer"
        public static let metricUptime = "power"
        public static let metricLoadAverage = "cpu"
        public static let metricMemoryUsage = "memorychip"
        public static let piholeSetupMonitor = "binoculars"
        public static let piMonitorInfoButton = "info.circle"
        public static let deleteButton = "minus.circle.fill"
        public static let piStatsSourceCode = "terminal"
        public static let piStatsMacOS = "desktopcomputer"
        public static let leaveReview = "heart"
        public static let customizeDisableTimes = "clock"
        public static let addNewCustomDisableTime = "plus"
        public static let piMonitorTemperature = "thermometer"

        public static let domainsOnBlockList = "list.bullet"
        public static let totalQueries = "globe"
        public static let queriesBlocked = "hand.raised"
        public static let percentBlocked = "chart.pie"
    }
}
