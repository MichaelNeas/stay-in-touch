//
//  ContactDetailViewController.swift
//  StayInTouch
//
//  Created by Michael Neas on 9/8/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    var activeContact: PhoneContact?
    
    override func loadView() {
        guard let contact = activeContact else {
            view = UIView()
            return
        }
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let contactDetailView = ContactDetailView(frame: frame, contact: contact)
        view = contactDetailView
    }
}
