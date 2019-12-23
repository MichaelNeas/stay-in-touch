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

class PhoneContacts {
    func getContacts(filter: ContactsFilter = .none) -> [CNContact] {
        let contactStore = CNContactStore()
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
    
    func contact(phoneNumber: String, context: ContactContext) {
        guard phoneNumber.isValid(regex: .phone) == true else { return }
        let validNumber = phoneNumber.onlyDigits().prepend(context.rawValue)
        
        if let url = URL(string: validNumber), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func contact(email: String) {
        if let url = URL(string: email), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
