//
//  DisableDurationManager.swift
//  PiStatsMobile
//
//  Created by Fernando Bunn on 26/09/2020.
//

import Foundation
import Combine

public class DisableTimeItem: Identifiable, Hashable {
    internal init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public static func == (lhs: DisableTimeItem, rhs: DisableTimeItem) -> Bool {
        return lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private lazy var formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .full
        f.allowedUnits = [.second, .minute, .hour]
        return f
    }()
    
    public let id = UUID()
    @Published public var timeInterval: TimeInterval

    public var title: String {
        formatter.string(from: timeInterval) ?? "-"
    }
}

public final class DisableDurationManager: ObservableObject {
    public static let shared = DisableDurationManager(userPreferences: .shared)

    private let userPreferences: UserPreferences
    @Published public var items = [DisableTimeItem]()
    private var disableTimeCancellable: AnyCancellable?
    private var timeIntervalCancellables: [AnyCancellable]?

    public init(userPreferences: UserPreferences) {
        self.userPreferences = userPreferences
        self.items = userPreferences.disableTimes.map { DisableTimeItem(timeInterval: $0) }
        setupCancellables()
    }
    
    public func saveDurationTimes() {
        userPreferences.disableTimes = items.map { $0.timeInterval }
        update()
    }
    
    /*
     I need to setup this cancellabes *with* the update method because of the issue on the
     ForEach that doesn't like to work with bindables on a loop.
     So this is to force the UI to be refreshed once a property changes.
     I'm pretty sure there is a best way of doing this though :(
     */
    public func setupCancellables() {
        disableTimeCancellable = $items.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.saveDurationTimes()
        }
        timeIntervalCancellables = items.map { $0.$timeInterval.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.saveDurationTimes()
        } }
    }
    
    public func update() {
        objectWillChange.send()
    }
    
    public func addNewItem() {
        items.append(DisableTimeItem(timeInterval: 0))
        setupCancellables()
    }
    
    public func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        setupCancellables()
    }
}
