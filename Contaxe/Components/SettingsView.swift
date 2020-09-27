//
//  SettingsView.swift
//  Contaxe
//
//  Created by Michael Neas on 9/26/20.
//

import SwiftUI

struct SettingsView: View {
    @Binding var presented: Bool
    @ObservedObject var notifications: Notifications
    @ObservedObject var settings: Settings
    
    var body: some View {
        ZStack {
            headerNav
            ScrollView {
                VStack {
                    enableNotifications(text: "Notifications Enabled")
                    if settings.wantsNotifications {
                        VStack {
                            if !settings.randomMode {
                            // frequency
                            Picker("Frequency", selection: $settings.selectedFrequency) {
                                ForEach(Frequency.allCases) { freq in
                                    Text(freq.description).tag(freq)
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            
                            Text("Selected: \(settings.selectedFrequency.description)")
                            
                            // time of day
                            DatePicker("Time of Day", selection: $settings.timeOfDay, displayedComponents: [.hourAndMinute])
                            }
                            
                            // random mode
                            Toggle(isOn: $settings.randomMode, label: {
                                Text("Random Mode")
                            })
                        }.padding()
                    }
                }
            }.padding(.top, 40)
        }
    }
    
    private func enableNotifications(text: String) -> some View {
        let notificationBinding: Binding<Bool> = Binding(get: {
            settings.wantsNotifications
        }, set: { value in
            if value == true && notifications.authorizationStatus == .denied {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            } else if value == true {
                notifications.registerLocal()
            }
            
            if value == false {
                notifications.removeNotifications()
            }
            
            settings.wantsNotifications = value
        })
        
        return Toggle(isOn: notificationBinding) {
            Text(text)
        }.padding()
    }
    
    private var headerNav: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.presented = false
                        }
                        notifications.setupNotifications(for: settings.timeOfDay, on: .daily)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }.padding()
                HStack(alignment: .center){
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
    }
}
