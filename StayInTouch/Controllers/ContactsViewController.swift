//
//  ContactsViewController.swift
//  StayInTouch
//
//  Created by Michael Neas on 5/10/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import UIKit
import ContactsUI

class ContactsViewController: UIViewController {
    
    var phoneContacts = [PhoneContact]()
    var filter: ContactsFilter = .none
    let contactViewController = ContactMethodViewController()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var letsGoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContacts(filter: filter)
        nameLabel.isHidden = true
        
        addChild(contactViewController)
        contactViewController.view.isHidden = true
        view.addSubview(contactViewController.view)
        contactViewController.view.frame = CGRect(x: 0, y: view.center.y, width: view.bounds.width, height: view.bounds.height / 2)
        contactViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contactViewController.didMove(toParent: self)
    }
    
    @IBAction func letsGoButtonAction(_ sender: Any) {
        contactViewController.view.isHidden = false
        nameLabel.text = phoneContacts.randomElement()?.name
        nameLabel.isHidden = false
    }
    
    fileprivate func loadContacts(filter: ContactsFilter) {
        phoneContacts.removeAll()
        for contact in PhoneContacts.getContacts(filter: filter) {
            phoneContacts.append(PhoneContact(contact: contact))
        }
    }
}
