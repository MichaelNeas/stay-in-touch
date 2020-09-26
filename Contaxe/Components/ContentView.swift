//
//  ContentView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var phoneContacts = [PhoneContact]()
    @ObservedObject var notifications = Notifications()
    @ObservedObject var settings = Settings()
    @State var contact: PhoneContact
    @State var showSettings: Bool = false
    
    init(contacts: [PhoneContact]) {
        self.phoneContacts = contacts
        self._contact = .init(initialValue: contacts.randomElement() ?? PhoneContact())
    }
    
    var body: some View {
        ZStack {
            if showSettings {
                Group {
                    SettingsView(presented: $showSettings, notifications: notifications, settings: settings)
                }.transition(.move(edge: .trailing)).animation(.easeOut)
            } else {
                Group {
                    ContactView(contact: $contact, connect: PhoneContacts())
                    topBar
                }
            }
        }
    }
    
    var topBar: some View {
        VStack {
            HStack {
                Button(action: { self.contact = self.phoneContacts.randomElement() ?? PhoneContact() }) {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.system(size: 36, weight: .thin))
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showSettings = true
                    }
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 36, weight: .thin))
                        .foregroundColor(.gray)
                }
            }.padding()
            Spacer()
        }
    }
}
