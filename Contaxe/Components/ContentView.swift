//
//  ContentView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var phoneContacts: PhoneContacts
    @ObservedObject var notifications = Notifications()
    @ObservedObject var settings = Settings()
    @State var showSettings: Bool = false
    
    init(contacts: PhoneContacts) {
        self.phoneContacts = contacts
    }
    
    var body: some View {
        ZStack {
            if showSettings {
                Group {
                    SettingsView(presented: $showSettings, notifications: notifications, settings: settings)
                }.transition(.move(edge: .trailing)).animation(.easeInOut, value: 1)
            } else {
                Group {
                    ContactView(connect: phoneContacts)
                    topBar
                }
            }
        }
    }
    
    var topBar: some View {
        VStack {
            HStack {
                #if DEBUG
                Button(action: {
                    phoneContacts.newActiveContact()
                }) {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.system(size: 36, weight: .thin))
                        .foregroundColor(.gray)
                }
                #endif
                Button(action: {
                    phoneContacts.deleteContact()
                }) {
                    Text("Delete")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.red)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        showSettings = true
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
