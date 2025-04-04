//
//  ContactsService.swift
//  Contaxe
//
//  Created by Michael Neas on 4/4/25.
//

import Foundation
import Contacts
import UIKit

enum ContactMethod {
    case phone
    case facetime
    case sms
    case email
    
    var urlSchemePrefix: String {
        switch self {
        case .phone: return "tel://"
        case .facetime: return "facetime://"
        case .sms: return "sms:+"
        case .email: return "mailto:"
        }
    }
    
    var isPhoneBased: Bool {
        self != .email
    }
}

protocol ContactActionsServicing {
    func contact(_ value: String, method: ContactMethod)
}

final class ContactsActionsService: ContactActionsServicing {
    
    func contact(_ value: String, method: ContactMethod) {
        guard method.isPhoneBased ? value.isValid(regex: .phone) : value.isValid(regex: .email) else {
            print("Invalid contact value: \(value)")
            return
        }

        var cleanedValue = value
        if method.isPhoneBased {
            cleanedValue = value.onlyDigits
            if let first = cleanedValue.first, first != "1" {
                cleanedValue = "1" + cleanedValue
            }
        }

        let fullURL = method.urlSchemePrefix + cleanedValue

        if let url = URL(string: fullURL), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Cannot open URL: \(fullURL)")
        }
    }
}
