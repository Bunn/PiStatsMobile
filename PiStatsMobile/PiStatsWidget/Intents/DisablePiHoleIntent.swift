import WidgetKit
import AppIntents
import OSLog

@available(iOS 17.0, *)
struct DisablePiHoleIntent: AppIntent {
    static var title: LocalizedStringResource = "Disable Pi-Hole"

    @Parameter(title: "Pi-Hole", requestValueDialog: "Which Pi-Hole?")
    var pihole: PiholeEntity?

    @Parameter(title: "Duration")
    var duration: DisableTimeEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Disable \(\.$pihole) for \(\.$duration)")
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        OSLogger.intents.debug("\(String(describing: type(of: self))) Perform")

        guard let pihole else {
            OSLogger.intents.debug("Throwing needsValueError for pihole")
            throw $pihole.needsValueError()
        }

        return .result(dialog: "Disabling \(pihole) for \(duration)")
    }
}
