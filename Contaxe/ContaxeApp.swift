//
//  ContaxeApp.swift
//  Contaxe
//
//  Created by Michael Neas on 9/26/20.
//

import SwiftUI

@main
struct ContaxeApp: App {
    let phoneContacts = PhoneContacts().getContacts().compactMap { PhoneContact(contact: $0) }
    
    var body: some Scene {
        WindowGroup {
            ContentView(contacts: phoneContacts)
        }
    }
}
