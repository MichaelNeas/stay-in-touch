import Foundation
import Contacts
import UIKit

enum ContactMethod {
    case phone, facetime, sms, email

    var urlSchemePrefix: String {
        switch self {
        case .phone:    "tel://"
        case .facetime: "facetime://"
        case .sms:      "sms:+"
        case .email:    "mailto:"
        }
    }

    var isPhoneBased: Bool { self != .email }
}

protocol ContactActionsServicing {
    func contact(_ value: String, method: ContactMethod)
}

struct ContactsActionsService: ContactActionsServicing {
    func contact(_ value: String, method: ContactMethod) {
        guard method.isPhoneBased ? value.isValid(regex: .phone) : value.isValid(regex: .email) else {
            return
        }

        var cleanedValue = value
        if method.isPhoneBased {
            // Preserve a leading + so international numbers aren't mangled
            let hasCountryCode = value.trimmingCharacters(in: .whitespaces).hasPrefix("+")
            cleanedValue = value.onlyDigits
            if !hasCountryCode && cleanedValue.count == 10 {
                // Assume US number — prepend country code
                cleanedValue = "1" + cleanedValue
            }
        }

        let urlString = method.urlSchemePrefix + cleanedValue
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
