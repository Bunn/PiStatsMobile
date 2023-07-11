import Foundation
import AppIntents

@available(iOS 17.0, *)
struct PiStatsShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: DisablePiHoleIntent(targetPiHole: .allPiHolesProxy, duration: .indefinitely),
            phrases: ["Disable All Pi-Holes in \(.applicationName)"],
            shortTitle: "Disable Pi-Holes",
            systemImageName: "lightswitch.off"
        )
    }
}
