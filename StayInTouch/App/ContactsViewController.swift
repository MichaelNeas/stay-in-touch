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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContacts(filter: filter)
    }
    
    func phoneNumberWithContryCode() -> [String] {
        
        let contacts = PhoneContacts.getContacts()
        var arrPhoneNumbers = [String]()
        for contact in contacts {
            for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
                let fulMobNumVar = ContctNumVar.value
                //let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
                if let MccNamVar = fulMobNumVar.value(forKey: "digits") as? String {
                    arrPhoneNumbers.append(MccNamVar)
                }
            }
        }
        return arrPhoneNumbers
    }
    
    fileprivate func loadContacts(filter: ContactsFilter) {
        phoneContacts.removeAll()
        var allContacts = [PhoneContact]()
        for contact in PhoneContacts.getContacts(filter: filter) {
            allContacts.append(PhoneContact(contact: contact))
        }
        
        var filterdArray = [PhoneContact]()
        if self.filter == .mail {
            filterdArray = allContacts.filter({ $0.email.count > 0 }) // getting all email
        } else if self.filter == .message {
            filterdArray = allContacts.filter({ $0.phoneNumber.count > 0 })
        } else {
            filterdArray = allContacts
        }
        phoneContacts.append(contentsOf: filterdArray)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        let text = phoneContacts[indexPath.row].name
        cell.textLabel?.text = text
        return cell
    }
}
