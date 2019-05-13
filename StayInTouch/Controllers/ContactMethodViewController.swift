//
//  ContactMethodViewController.swift
//  StayInTouch
//
//  Created by Michael Neas on 5/10/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import Foundation
import UIKit

enum ContactContext: String {
    case phone = "tel://"
    case facetime = "facetime://"
    case sms = "sms:"
    case email = "mailto:"
}

class ContactMethodViewController: UIViewController, ContactMethodViewDelegate {
    func viewSwiped(_ direction: UISwipeGestureRecognizer.Direction) {
        parentController?(direction)
    }
    
    var activeContact: PhoneContact?
    var parentController: ((UISwipeGestureRecognizer.Direction)->())?
    
    func buttonTapped(_ context: ContactContext) {
        guard let activeContact = activeContact else { return }
        if context == .email {
            guard activeContact.email.count > 0 else { return }
            contact(email: activeContact.email[0].prepend(context.rawValue))
            return
        }
        guard activeContact.phoneNumber.count > 0 else { return }
        contact(phoneNumber: activeContact.phoneNumber[0], context: context)
    }
    
    override func loadView() {
        let contactMethodView = ContactMethodView()
        contactMethodView.delegate = self
        view = contactMethodView
    }

    private func contact(phoneNumber: String, context: ContactContext) {
        guard phoneNumber.isValid(regex: .phone) == true else { return }
        let validNumber = phoneNumber.onlyDigits().prepend(context.rawValue)
        
        if let url = URL(string: validNumber), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func contact(email: String) {
        if let url = URL(string: email), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
