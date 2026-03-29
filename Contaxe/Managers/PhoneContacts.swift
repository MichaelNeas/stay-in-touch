import Foundation
import Contacts

protocol ContactsServicing {
    func requestAccess() async throws
    func fetchContacts() async throws -> [PhoneContact]
    func delete(contact: PhoneContact) throws
}

struct PhoneContactsService: ContactsServicing {
    private let store = CNContactStore()

    func requestAccess() async throws {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .notDetermined else { return }
        _ = try await store.requestAccess(for: .contacts)
    }

    func fetchContacts() async throws -> [PhoneContact] {
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

        return contacts.map(PhoneContact.init)
    }

    func delete(contact: PhoneContact) throws {
        let request = CNSaveRequest()
        let mutable = contact.contact.mutableCopy() as! CNMutableContact
        request.delete(mutable)
        try store.execute(request)
    }
}
