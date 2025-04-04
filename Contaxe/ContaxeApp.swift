//
//  ContaxeApp.swift
//  Contaxe
//
//  Created by Michael Neas on 9/26/20.
//

import SwiftUI

@main
struct ContaxeApp: App {
    let contactService = PhoneContactsService()
    let contactActionsService = ContactsActionsService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PhoneContactsViewModel(contactService: contactService, contactActionsService: contactActionsService))
        }
    }
}
