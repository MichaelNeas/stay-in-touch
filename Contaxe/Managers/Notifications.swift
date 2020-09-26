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
}
