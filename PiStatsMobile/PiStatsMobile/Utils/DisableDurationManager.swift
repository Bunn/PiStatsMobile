//
//  DisableDurationManager.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 26/09/2020.
//

import Foundation
import Combine

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
    @Published var timeInterval: TimeInterval
    
    var title: String {
        formatter.string(from: timeInterval) ?? "-"
    }
}

class DisableDurationManager: ObservableObject {
    private let userPreferences: UserPreferences
    @Published var items = [DisableTimeItem]()
    private var disableTimeCancellable: AnyCancellable?
    private var timeIntervalCancellables: [AnyCancellable]?

    internal init(userPreferences: UserPreferences) {
        self.userPreferences = userPreferences
        self.items = userPreferences.disableTimes.map { DisableTimeItem(timeInterval: $0) }
        setupCancellables()
    }
    
    func saveDurationTimes() {
        userPreferences.disableTimes = items.map { $0.timeInterval }
        update()
    }
    
    func setupCancellables() {
        disableTimeCancellable = $items.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.saveDurationTimes()
        }
        timeIntervalCancellables = items.map { $0.$timeInterval.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.saveDurationTimes()
        } }
    }
    
    func update() {
        objectWillChange.send()
    }
    
    func addNewItem() {
        items.append(DisableTimeItem(timeInterval: 30))
        setupCancellables()
    }
    
    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        setupCancellables()
    }
}
