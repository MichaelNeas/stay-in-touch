//
//  Notifications.swift
//  Contaxe
//
//  Created by Michael Neas on 9/26/20.
//

import Foundation
import UserNotifications

class Notifications: ObservableObject {
    @Published var authorizationStatus: UNAuthorizationStatus = UNAuthorizationStatus.notDetermined
    
    var hasPermission: Bool {
        ![.denied, .notDetermined].contains(authorizationStatus)
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        checkAuthorizationStatus()
    }
    
    func removeNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    
    func registerLocal() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings(completionHandler: { settings in
            self.authorizationStatus = settings.authorizationStatus
        })
    }
    
    func setupNotifications(for date: Date, on interval: Frequency) {
        let content = UNMutableNotificationContent()
        content.title = "New contact today!"
        //content.body = "Every Tuesday at 2pm"
//        content.subtitle = "It looks hungry"
//        content.sound = UNNotificationSound.default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.calendar = Calendar.current

        
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
    }
}
