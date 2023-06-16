import WidgetKit
import AppIntents
import OSLog

@available(iOS 17.0, *)
struct RefreshWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Refresh"

    func perform() async throws -> some IntentResult {
        OSLogger.intents.debug("\(String(describing: type(of: self))) Perform")
        return .result()
    }
}
