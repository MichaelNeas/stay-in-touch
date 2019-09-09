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
    let contactDetailViewController = ContactDetailViewController()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var letsGoButton: UIButton!
    
    lazy var pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.backgroundColor = .black
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.layer.cornerRadius = 40
        return pictureView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContacts(filter: filter)
        nameLabel.isHidden = true
        pictureView.isHidden = true
        let vcs: [UIViewController] = [contactDetailViewController, contactViewController]
        for vc in vcs {
            addChild(vc)
            vc.view.isHidden = true
            vc.view.alpha = 0.0
            view.addSubview(vc.view)
            vc.view.frame = CGRect(x: 0, y: (view.center.y - 20), width: view.bounds.width, height: (view.bounds.height / 2) + 20)
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vc.didMove(toParent: self)
            vc.view.transform = CGAffineTransform(translationX: 0, y: view.frame.midY)
        }

        nameLabel.transform = CGAffineTransform(translationX: -1 * (view.frame.midX + (nameLabel.frame.width / 2)), y: 0)
        pictureView.transform = CGAffineTransform(translationX: -1 * (view.frame.midX + (nameLabel.frame.width / 2)), y: 0)
        view.addSubview(pictureView)
        setupConstraints()
        
        
        contactViewController.parentController = childSwipeHandler
    }
    
    @IBAction func letsGoButtonAction(_ sender: Any) {
        guard let randomContact = phoneContacts.randomElement() else { return }
        showContactMethodView(of: randomContact)
        showLabel(name: randomContact.name)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 80),
            pictureView.heightAnchor.constraint(equalTo: pictureView.widthAnchor),
            pictureView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -15),
            pictureView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func childSwipeHandler(direction: UISwipeGestureRecognizer.Direction) {
        let replacementContact = ContactMethodViewController()
        
        var directionTransform: CGAffineTransform = CGAffineTransform()
        switch direction {
        case .left:
            directionTransform = CGAffineTransform(translationX: -view.frame.width, y: 0)
        case .right:
            directionTransform = CGAffineTransform(translationX: view.frame.width, y: 0)
        default:
            print("direction not handled")
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.1, options: .curveEaseInOut, animations: {
            
            replacementContact.view.transform = directionTransform
        }, completion: nil)
    }
    
    private func showLabel(name: String?) {
        let right = CGAffineTransform(translationX: 0, y: 0)
        nameLabel.text = name
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.nameLabel.isHidden = false
            self.nameLabel.transform = right
            self.pictureView.isHidden = false
            self.pictureView.transform = right
        }, completion: nil)
    }
    
    private func showContactMethodView(of contact: PhoneContact) {
        contactViewController.activeContact = contact
        contactDetailViewController.activeContact = contact
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
