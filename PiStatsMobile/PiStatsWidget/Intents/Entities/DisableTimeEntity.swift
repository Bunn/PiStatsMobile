import Foundation
import AppIntents

@available(iOS 17.0, *)
struct DisableTimeEntity: AppEntity {

    var id: UUID
    var title: String
    var interval: TimeInterval

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Duration"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    static var defaultQuery = DisableTimeQuery()

}

@available(iOS 17.0, *)
struct DisableTimeQuery: EntityQuery {

    func suggestedEntities() async throws -> [DisableTimeEntity] { DisableTimeEntity.all }

    func entities(for identifiers: [DisableTimeEntity.ID]) async throws -> [DisableTimeEntity] {
        guard !identifiers.isEmpty else { return DisableTimeEntity.all }

        return identifiers.compactMap { id in
            DisableDurationManager.shared.items.first(where: { $0.id == id })
                .map(DisableTimeEntity.init)
        }
    }

}

@available(iOS 17.0, *)
extension DisableTimeEntity {
    init(_ item: DisableTimeItem) {
        self.init(id: item.id, title: item.title, interval: item.timeInterval)
    }

    static var all: [DisableTimeEntity] { DisableDurationManager.shared.items.map(DisableTimeEntity.init) }
}
