import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @Environment(Notifications.self) private var notifications
    @Environment(Settings.self) private var settings

    // Calendar.weekdaySymbols: index 0 = Sunday, index 6 = Saturday
    // Calendar weekday component: 1 = Sunday … 7 = Saturday
    private let weekdays = Calendar.current.weekdaySymbols

    var body: some View {
        @Bindable var settings = settings

        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Settings")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                HStack {
                    Button(action: saveAndDismiss) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Back")
                    .accessibilityHint("Save settings and return")
                    Spacer()
                }
            }
            .padding()
            .background(.ultraThinMaterial)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Toggle("Enable Reminders", isOn: $settings.wantsNotifications)
                        .tint(Color.darkPurple)
                        .padding()
                        .onChange(of: settings.wantsNotifications) { _, enabled in
                            handleNotificationToggle(enabled)
                        }

                    if settings.wantsNotifications {
                        Divider().padding(.leading)

                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Frequency")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Picker("Frequency", selection: $settings.selectedFrequency) {
                                    ForEach(Frequency.allCases) { freq in
                                        Text(freq.description).tag(freq)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }

                            HStack {
                                if settings.selectedFrequency == .weekly {
                                    Picker("Day", selection: $settings.notificationWeekday) {
                                        ForEach(1...7, id: \.self) { day in
                                            Text(weekdays[day - 1]).tag(day)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                }

                                DatePicker(
                                    "Time",
                                    selection: $settings.timeOfDay,
                                    displayedComponents: .hourAndMinute
                                )
                            }
                        }
                        .padding()
                    }
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }

    private func saveAndDismiss() {
        if settings.wantsNotifications {
            notifications.schedule(
                for: settings.timeOfDay,
                frequency: settings.selectedFrequency,
                weekday: settings.selectedFrequency == .weekly ? settings.notificationWeekday : nil
            )
        }
        withAnimation { isPresented = false }
    }

    private func handleNotificationToggle(_ enabled: Bool) {
        guard enabled else {
            notifications.removeAll()
            return
        }
        Task { await handleEnablingNotifications() }
    }

    @MainActor
    private func handleEnablingNotifications() async {
        switch notifications.authorizationStatus {
        case .denied:
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url)
            }
            settings.wantsNotifications = false
        case .notDetermined:
            let granted = await notifications.requestAuthorization()
            if !granted { settings.wantsNotifications = false }
        default:
            break
        }
    }
}
