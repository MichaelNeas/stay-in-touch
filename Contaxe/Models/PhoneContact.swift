import Foundation
import Contacts

struct PhoneContact: Identifiable {
    let contact: CNContact

    var id: String { contact.identifier }

    var name: String {
        CNContactFormatter.string(from: contact, style: .fullName) ?? "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
    }

    var avatarData: Data? { contact.thumbnailImageData }

    var phoneNumbers: [String] {
        contact.phoneNumbers.map { $0.value.stringValue }
    }

    var emails: [String] {
        contact.emailAddresses.map { $0.value as String }
    }

    var location: String {
        guard let address = contact.postalAddresses.first?.value else { return "" }
        let parts = [address.city, address.state].filter { !$0.isEmpty }
        return parts.joined(separator: ", ")
    }

    var initials: String {
        let first = contact.givenName.first.map(String.init) ?? ""
        let last = contact.familyName.first.map(String.init) ?? ""
        let result = first + last
        return result.isEmpty ? "?" : result
    }

    var isEmpty: Bool { name.isEmpty }
}
