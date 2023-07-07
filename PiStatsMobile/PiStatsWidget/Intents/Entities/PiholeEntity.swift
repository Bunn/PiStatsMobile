import Foundation
import AppIntents

@available(iOS 17.0, *)
struct PiholeEntity: AppEntity {

    var id: UUID
    var name: String

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Pi-Hole"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static var defaultQuery = PiholeQuery()

}

@available(iOS 17.0, *)
struct PiholeQuery: EntityQuery {

    func suggestedEntities() async throws -> [PiholeEntity] { PiholeEntity.all }

    func entities(for identifiers: [PiholeEntity.ID]) async throws -> [PiholeEntity] {
        guard !identifiers.isEmpty else { return PiholeEntity.all }
        return identifiers.compactMap { Pihole.restore($0).map(PiholeEntity.init) }
    }

}

@available(iOS 17.0, *)
extension PiholeEntity {
    init(_ pihole: Pihole) {
        self.init(id: pihole.id, name: pihole.displayName ?? pihole.address)
    }

    static var all: [PiholeEntity] { Pihole.restoreAll().map(PiholeEntity.init) }
}
