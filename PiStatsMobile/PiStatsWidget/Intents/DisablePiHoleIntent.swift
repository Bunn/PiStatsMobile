import WidgetKit
import AppIntents
import OSLog
import PiStatsKit

@available(iOS 17.0, *)
struct DisablePiHoleIntent: AppIntent {
    static var title: LocalizedStringResource = "Disable Pi-Hole"

    @Parameter(title: "Pi-Hole", requestValueDialog: "Which Pi-Hole?")
    var targetPiHole: PiholeEntity?

    @Parameter(title: "Duration")
    var duration: DisableTimeEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Disable \(\.$targetPiHole) \(\.$duration)")
    }

    init(targetPiHole: PiholeEntity? = nil, duration: DisableTimeEntity) {
        self.targetPiHole = targetPiHole
        self.duration = duration
    }

    init() { }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        OSLogger.intents.debug("\(String(describing: type(of: self))) Perform")

        guard let targetPiHole else {
            OSLogger.intents.debug("Throwing needsValueError for pihole")
            throw $targetPiHole.needsValueError()
        }

        if targetPiHole.representsAllPiHoles {
            let piholes = Pihole.restoreAll()
            
            var disabled = Set<Pihole>()
            var failed = Set<Pihole>()
            
            for pihole in piholes {
                do {
                    OSLogger.intents.debug("Disabling \(pihole.address)")
                    
                    try await pihole.disable(for: Int(duration.interval))
                    
                    disabled.insert(pihole)
                    
                    OSLogger.intents.debug("\(pihole.address) disabled successfully")
                } catch {
                    OSLogger.intents.error("Error disabling \(pihole.address): \(error, privacy: .public)")
                    
                    failed.insert(pihole)
                }
            }
            
            if failed.isEmpty {
                if duration == .indefinitely {
                    return .result(dialog: "Disabled \(piholes.count) Pi-Hole(s)")
                } else {
                    return .result(dialog: "Disabled \(piholes.count) Pi-Hole(s) for \(duration)")
                }
            } else if disabled.isEmpty {
                throw CocoaError(.xpcConnectionInvalid, userInfo: [NSLocalizedDescriptionKey: "Error disabling Pi-Hole(s)"])
            } else {
                return .result(dialog: "Disabled \(disabled.count) Pi-Hole(s). \(failed.count) Pi-Hole(s) couldn't be disabled.")
            }
        } else {
            guard let pihole = Pihole.restore(targetPiHole.id) else {
                OSLogger.intents.error("Couldn't find a Pi-Hole with ID \(targetPiHole.id, privacy: .public)")
                throw CocoaError(.coderValueNotFound, userInfo: [NSLocalizedDescriptionKey: "Couldn't find the specified Pi-Hole"])
            }

            try await pihole.disable(for: Int(duration.interval))

            if duration == .indefinitely {
                return .result(dialog: "\(targetPiHole) disabled")
            } else {
                return .result(dialog: "\(targetPiHole) disabled for \(duration)")
            }
        }
    }
}
