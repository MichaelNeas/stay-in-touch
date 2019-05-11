//
//  ContactMethodView.swift
//  StayInTouch
//
//  Created by Michael Neas on 5/10/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import Foundation
import UIKit

class ContactMethodView: UIView {
    
    enum ContactContext: String {
        case phone = "tel://"
        case facetime = "facetime://"
        case sms = "sms:"
    }
    
    func contact(phoneNumber: String, context: ContactContext) {
        guard phoneNumber.isValid(regex: .phone) == true else { return }
        let validNumber = phoneNumber.onlyDigits().prepend(context.rawValue)
        
        if let url = URL(string: validNumber), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
//        let email = "foo@bar.com"
//        if let url = URL(string: "mailto:\(email)") {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
    }
}
