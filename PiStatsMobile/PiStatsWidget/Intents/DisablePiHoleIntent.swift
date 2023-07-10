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
        Summary("Disable \(\.$targetPiHole) for \(\.$duration)")
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        OSLogger.intents.debug("\(String(describing: type(of: self))) Perform")

        guard let targetPiHole else {
            OSLogger.intents.debug("Throwing needsValueError for pihole")
            throw $targetPiHole.needsValueError()
        }

        guard let pihole = Pihole.restore(targetPiHole.id) else {
            OSLogger.intents.error("Couldn't find a Pi-Hole with ID \(targetPiHole.id, privacy: .public)")
            throw CocoaError(.coderValueNotFound, userInfo: [NSLocalizedDescriptionKey: "Couldn't find the specified Pi-Hole"])
        }

        try await pihole.disable(for: Int(duration.interval))

        return .result(dialog: "Disabling \(targetPiHole) for \(duration)")
    }
}
