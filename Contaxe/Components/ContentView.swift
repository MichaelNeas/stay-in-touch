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
    var body: some View {
        ContactView(contact: phoneContacts.randomElement() ?? PhoneContact(), connect: PhoneContacts())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
