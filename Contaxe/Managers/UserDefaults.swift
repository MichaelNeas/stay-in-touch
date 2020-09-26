//
//  UserDefaults.swift
//  Contaxe
//
//  Created by Michael Neas on 9/26/20.
//

import Foundation

class Settings: ObservableObject {
    enum Keys: String {
        case frequency
        case notifications
        case time
        case random
    }
    
    @Published var wantsNotifications: Bool {
        didSet {
            UserDefaults.standard.set(wantsNotifications, forKey: Keys.notifications.rawValue)
        }
    }
    
    @Published var selectedFrequency: Frequency {
        didSet {
            UserDefaults.standard.set(selectedFrequency.rawValue, forKey: Keys.frequency.rawValue)
        }
    }
    @Published var timeOfDay: Date {
        didSet {
            UserDefaults.standard.set(timeOfDay, forKey: Keys.time.rawValue)
        }
    }
    @Published var randomMode: Bool {
        didSet {
            UserDefaults.standard.set(randomMode, forKey: Keys.random.rawValue)
        }
    }
    
    init() {
        selectedFrequency = Frequency(rawValue: UserDefaults.standard.string(forKey: Keys.frequency.rawValue) ?? Frequency.daily.rawValue) ?? .daily
        wantsNotifications = UserDefaults.standard.bool(forKey: Keys.notifications.rawValue)
        timeOfDay = UserDefaults.standard.object(forKey: Keys.time.rawValue) as? Date ?? Date()
        randomMode = UserDefaults.standard.bool(forKey: Keys.random.rawValue)
    }
}
