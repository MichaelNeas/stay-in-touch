//
//  PhoneContacts.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import Foundation
import ContactsUI

enum ContactsFilter {
    case none
    case mail
    case message
}

enum ContactContext: String {
    case phone = "tel://"
    case facetime = "facetime://"
    case sms = "sms:+"
    case email = "mailto:"
}

class PhoneContacts: ObservableObject {
    @Published var phoneContacts: [PhoneContact] = []
    @Published var activeContact: PhoneContact = PhoneContact()
    
    let contactStore = CNContactStore()
    
    init() {
        self.phoneContacts = self.getContacts().compactMap { PhoneContact(contact: $0) }
        newActiveContact()
    }
    
    func getContacts(filter: ContactsFilter = .none) -> [CNContact] {
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactPostalAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var results: [CNContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        
        return results
    }
    
    func newActiveContact() {
        activeContact = phoneContacts.randomElement() ?? PhoneContact()
    }
    
    func deleteContact() {
        let request = CNSaveRequest()
        let mutableContact = activeContact.contact.mutableCopy() as! CNMutableContact
        request.delete(mutableContact)
        do {
            try contactStore.execute(request)
            newActiveContact()
        } catch {
            print("Error deleting contact")
        }
    }
    
    func contact(phoneNumber: String, context: ContactContext) {
        guard phoneNumber.isValid(regex: .phone) == true else { return }
        var validNumber = phoneNumber.onlyDigits()
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
