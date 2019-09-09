//
//  ContactDetailView.swift
//  StayInTouch
//
//  Created by Michael Neas on 9/8/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import UIKit

class ContactDetailView: UIView {
    let contact: PhoneContact
    lazy var detailStack: UIStackView = {
        let detailStack = UIStackView()
        return detailStack
    }()
    
    init(frame: CGRect, contact: PhoneContact) {
        self.contact = contact
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
