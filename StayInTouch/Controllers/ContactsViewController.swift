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
        self.contactViewController.view.alpha = 0.0
        view.addSubview(contactViewController.view)
        contactViewController.view.frame = CGRect(x: 0, y: (view.center.y - 20), width: view.bounds.width, height: (view.bounds.height / 2) + 20)
        contactViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contactViewController.didMove(toParent: self)
        contactViewController.view.transform = CGAffineTransform(translationX: 0, y: view.frame.midY)
        nameLabel.transform = CGAffineTransform(translationX: -1 * (view.frame.midX + (nameLabel.frame.width / 2)), y: 0)
    }
    
    @IBAction func letsGoButtonAction(_ sender: Any) {
        guard let randomContact = phoneContacts.randomElement() else { return }
        showContactMethodView(of: randomContact)
        showLabel(name: randomContact.name)
    }
    
    private func showLabel(name: String?) {
        let right = CGAffineTransform(translationX: 0, y: 0)
        nameLabel.text = name
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.nameLabel.isHidden = false
            self.nameLabel.transform = right
        }, completion: nil)
    }
    
    private func showContactMethodView(of contact: PhoneContact) {
        contactViewController.activeContact = contact
        let up = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseInOut, animations: {
            self.contactViewController.view.isHidden = false
            self.contactViewController.view.alpha = 1.0
            self.contactViewController.view.transform = up
        }, completion: nil)
    }
    
    private func loadContacts(filter: ContactsFilter) {
        phoneContacts.removeAll()
        for contact in PhoneContacts.getContacts(filter: filter) {
            phoneContacts.append(PhoneContact(contact: contact))
        }
    }
}
