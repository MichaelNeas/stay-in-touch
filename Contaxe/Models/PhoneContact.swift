//
//  PhoneContact.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import Foundation
import Contacts

struct PhoneContact {
    let contact: CNContact
    
    var name: String {
        contact.givenName + " " + contact.familyName
    }

    var avatarData: Data? {
        contact.thumbnailImageData
    }
    
    var phoneNumbers: [String] {
        contact.phoneNumbers.map { $0.value.stringValue }
    }
    
    var emails: [String] {
        contact.emailAddresses.map { $0.value as String }
    }
    
    var location: String {
        var location = ""
        if let city = contact.postalAddresses.first?.value.city {
            location = city
        }
        if let state = contact.postalAddresses.first?.value.state {
            location += location.isEmpty ? state : ", \(state)"
        }
        return location
    }
    
    var initials: String {
        "\(contact.givenName.prefix(1) + contact.familyName.prefix(1))"
    }
    
    init(contact: CNContact) {
        self.contact = contact
    }
    
    func formattedPhoneNumbers() -> String {
        phoneNumbers.joined(separator: ", ")
    }
    
    func formattedEmails() -> String {
        emails.joined(separator: ", ")
    }
}

