import Foundation
import UserNotifications
import Observation

@Observable
@MainActor
final class Notifications {
    var authorizationStatus: UNAuthorizationStatus = .notDetermined

    var hasPermission: Bool {
        authorizationStatus == .authorized || authorizationStatus == .provisional
    }

    private let center = UNUserNotificationCenter.current()

    init() {
        Task { await refreshStatus() }
    }

    func refreshStatus() async {
        let settings = await center.notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            await refreshStatus()
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func removeAll() {
        center.removeAllPendingNotificationRequests()
    }

    func schedule(for time: Date, frequency: Frequency, weekday: Int? = nil) {
        removeAll()
        guard hasPermission else { return }

        let content = UNMutableNotificationContent()
        content.title = "Stay in Touch"
        content.body = "Connect with someone you care about."
        content.sound = .default

        var components = Calendar.current.dateComponents([.hour, .minute], from: time)

        if frequency == .weekly {
            components.weekday = weekday ?? Calendar.current.component(.weekday, from: Date())
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "stay-in-touch-reminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error { print("Failed to schedule notification: \(error)") }
        }
    }
}
