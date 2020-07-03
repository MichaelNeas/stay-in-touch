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
    @State var contact: PhoneContact
    
    init(contacts: [PhoneContact]) {
        self.phoneContacts = contacts
        self._contact = .init(initialValue: contacts.randomElement() ?? PhoneContact())
    }
    
    var body: some View {
        ZStack {
            ContactView(contact: $contact, connect: PhoneContacts())
            VStack {
                HStack {
                    Spacer()
                    Button(action: { self.contact = self.phoneContacts.randomElement() ?? PhoneContact() }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.system(size: 36, weight: .thin))
                            .foregroundColor(.gray)
                    }.padding()
                }
                Spacer()
            }
        }
        
    }
}
