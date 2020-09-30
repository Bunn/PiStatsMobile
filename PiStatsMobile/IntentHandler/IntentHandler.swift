//
//  IntentHandler.swift
//  IntentHandler
//
//  Created by Fernando Bunn on 30/09/2020.
//

import Intents

class IntentHandler: INExtension, SelectPiholeIntentHandling {
    
    func providePiholeOptionsCollection(for intent: SelectPiholeIntent, with completion: @escaping (INObjectCollection<PiholeIntent>?, Error?) -> Void) {
        let piholes = validPiholes().map {
            PiholeIntent(
                identifier: $0.id.uuidString,
                display: $0.title
            )
        }
        let collection = INObjectCollection(items: piholes)
        completion(collection, nil)
    }
    
    func defaultPihole(for intent: SelectPiholeIntent) -> PiholeIntent? {
        if let pihole = validPiholes().first {
            return PiholeIntent(
                identifier: pihole.id.uuidString,
                display: pihole.title
            )
        }
        return nil
    }
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
    private func validPiholes() -> [Pihole] {
        Pihole.restoreAll().filter{ $0.hasPiMonitor }
    }
}
