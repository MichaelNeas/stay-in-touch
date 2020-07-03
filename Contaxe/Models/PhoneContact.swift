//
//  PhoneContact.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import Foundation
import ContactsUI

class PhoneContact: NSObject {
    let contact: CNContact
    
    var name: String {
        contact.givenName + " " + contact.familyName
    }

    var avatarData: Data? {
        contact.thumbnailImageData
    }
    
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    
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
        
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
    
    override init() {
        self.contact = CNContact()
        super.init()
    }
}
