//
//  PhoneContactsViewModel.swift
//  Contaxe
//
//  Created by Michael Neas on 4/4/25.
//

import Foundation
import SwiftUI
import Contacts

class PhoneContactsViewModel: ObservableObject {
    @Published var phoneContacts: [PhoneContact] = []
    @Published var activeContact: PhoneContact

    private var contactService: ContactsServicing
    private var contactActionsService: ContactActionsServicing

    init(contactService: ContactsServicing, contactActionsService: ContactActionsServicing) {
        self.contactService = contactService
        self.contactActionsService = contactActionsService
        self.activeContact = PhoneContact(contact: CNContact())
        fetchContacts()
    }
    
    func fetchContacts() {
        Task {
            do {
                self.phoneContacts = try await contactService.fetchContacts()
                if let firstContact = self.phoneContacts.first {
                    self.activeContact = firstContact
                }
            } catch {
                print("Error fetching contacts: \(error.localizedDescription)")
            }
        }
    }

    func newActiveContact() {
        activeContact = phoneContacts.randomElement() ?? PhoneContact(contact: CNContact()) // Default contact
    }
    
    func deleteContact() {
        Task {
            do {
                try contactService.delete(contact: activeContact)
            } catch {
                print("Error deleting contact: \(error.localizedDescription)")
            }
        }
    }
    
    func text() {
        guard let phoneNumber = activeContact.phoneNumbers.first else { return }
        contactActionsService.contact(phoneNumber, method: .sms)
    }

    func call() {
        guard let phoneNumber = activeContact.phoneNumbers.first else { return }
        contactActionsService.contact(phoneNumber, method: .phone)
    }

    func email() {
        guard let email = activeContact.emails.first else { return }
        contactActionsService.contact(email, method: .email)
    }

    func faceTime() {
        guard let phoneNumber = activeContact.phoneNumbers.first else { return }
        contactActionsService.contact(phoneNumber, method: .facetime)
    }
}
