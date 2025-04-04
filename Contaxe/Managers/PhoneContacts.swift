//
//  PhoneContacts.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import Foundation
import ContactsUI

enum ContactContext: String {
    case phone = "tel://"
    case facetime = "facetime://"
    case sms = "sms:+"
    case email = "mailto:"
}

protocol ContactsServicing {
    func requestAccess() async throws
    func fetchContacts() async throws -> [PhoneContact]
    func delete(contact: PhoneContact) throws
}

final class PhoneContactsService: ContactsServicing {
    
    private let store = CNContactStore()

    func fetchContacts() async throws -> [PhoneContact]{
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPostalAddressesKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor
        ]
        
        let containers = try store.containers(matching: nil)
        var contacts: [CNContact] = []
        
        for container in containers {
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let containerContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            contacts.append(contentsOf: containerContacts)
        }
        
        return contacts.compactMap(PhoneContact.init)
    }
    
    func requestAccess() async throws {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .notDetermined {
            _ = try await store.requestAccess(for: .contacts)
        }
    }
    
    
    func delete(contact: PhoneContact) throws {
        let request = CNSaveRequest()
        let mutable = contact.contact.mutableCopy() as! CNMutableContact
        request.delete(mutable)
        try store.execute(request)
    }
    
    func contact(phoneNumber: String, context: ContactContext) {
        guard phoneNumber.isValid(regex: .phone) == true else { return }
        var validNumber = phoneNumber.onlyDigits
        if let first = validNumber.first, first != Character("1") {
            validNumber = validNumber.prepend("1")
        }
        if let url = URL(string: validNumber.prepend(context.rawValue)), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func contact(email: String) {
        if let url = URL(string: email), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
