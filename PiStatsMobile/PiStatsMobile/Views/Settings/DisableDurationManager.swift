//
//  DisableDurationManager.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 26/09/2020.
//

import Foundation


class DisableTimeItem: Identifiable, Hashable {
    internal init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    static func == (lhs: DisableTimeItem, rhs: DisableTimeItem) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private lazy var formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .full
        f.allowedUnits = [.second, .minute, .hour]
        return f
    }()
    let id = UUID()
    var timeInterval: TimeInterval
    var title: String {
        formatter.string(from: timeInterval) ?? "-"
    }
}

class DisableDurationManager {
    private let userPreferences: UserPreferences
    var items = [DisableTimeItem]()
    
    internal init(userPreferences: UserPreferences) {
        self.userPreferences = userPreferences
        self.items = userPreferences.disableTimes.map { DisableTimeItem(timeInterval: $0) }
    }
}
