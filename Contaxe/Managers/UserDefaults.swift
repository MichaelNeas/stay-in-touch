import Foundation
import Observation

@Observable
final class Settings {
    private enum Keys: String {
        case frequency, notifications, time, weekday
    }

    var wantsNotifications: Bool {
        didSet { UserDefaults.standard.set(wantsNotifications, forKey: Keys.notifications.rawValue) }
    }

    var selectedFrequency: Frequency {
        didSet { UserDefaults.standard.set(selectedFrequency.rawValue, forKey: Keys.frequency.rawValue) }
    }

    var timeOfDay: Date {
        didSet { UserDefaults.standard.set(timeOfDay, forKey: Keys.time.rawValue) }
    }

    // Calendar weekday: 1 = Sunday … 7 = Saturday. Default: Monday (2).
    var notificationWeekday: Int {
        didSet { UserDefaults.standard.set(notificationWeekday, forKey: Keys.weekday.rawValue) }
    }

    init() {
        let rawFrequency = UserDefaults.standard.string(forKey: Keys.frequency.rawValue) ?? ""
        selectedFrequency = Frequency(rawValue: rawFrequency) ?? .daily
        wantsNotifications = UserDefaults.standard.bool(forKey: Keys.notifications.rawValue)
        timeOfDay = UserDefaults.standard.object(forKey: Keys.time.rawValue) as? Date ?? Date()
        let savedWeekday = UserDefaults.standard.integer(forKey: Keys.weekday.rawValue)
        notificationWeekday = savedWeekday == 0 ? 2 : savedWeekday // 0 means not set; default Monday
    }
}
