import Foundation
import Contacts
import Observation

@Observable
@MainActor
final class PhoneContactsViewModel {
    var contacts: [PhoneContact] = []
    var activeContact: PhoneContact?
    var isLoading = false
    var permissionDenied = false

    private let contactService: ContactsServicing
    private let actionsService: ContactActionsServicing

    init(contactService: ContactsServicing, actionsService: ContactActionsServicing) {
        self.contactService = contactService
        self.actionsService = actionsService
        Task { await loadContacts() }
    }

    func loadContacts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await contactService.requestAccess()
            let status = CNContactStore.authorizationStatus(for: .contacts)
            permissionDenied = (status == .denied || status == .restricted)
            guard !permissionDenied else { return }
            contacts = try await contactService.fetchContacts()
            activeContact = contacts.randomElement()
        } catch {
            print("Error loading contacts: \(error.localizedDescription)")
        }
    }

    func nextContact() {
        activeContact = contacts.randomElement()
    }

    func deleteActiveContact() async {
        guard let contact = activeContact else { return }
        do {
            try contactService.delete(contact: contact)
            contacts.removeAll { $0.id == contact.id }
            activeContact = contacts.randomElement()
        } catch {
            print("Error deleting contact: \(error.localizedDescription)")
        }
    }

    func text() {
        guard let phone = activeContact?.phoneNumbers.first else { return }
        actionsService.contact(phone, method: .sms)
    }

    func call() {
        guard let phone = activeContact?.phoneNumbers.first else { return }
        actionsService.contact(phone, method: .phone)
    }

    func email() {
        guard let email = activeContact?.emails.first else { return }
        actionsService.contact(email, method: .email)
    }

    func faceTime() {
        guard let phone = activeContact?.phoneNumbers.first else { return }
        actionsService.contact(phone, method: .facetime)
    }
}
