//
//  UserDefaults.swift
//  Contaxe
//
//  Created by Michael Neas on 9/26/20.
//

import Foundation

class Settings: ObservableObject {
    @Published var wantsNotifications = UserDefaults.standard.bool(forKey: "notifications")
}
