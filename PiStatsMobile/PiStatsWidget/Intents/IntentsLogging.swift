import Foundation
import OSLog

typealias OSLogger = os.Logger

extension OSLogger {
    static let intents = OSLogger(subsystem: Bundle.main.bundleIdentifier ?? "PiStats", category: "PiStatsIntents")
}
