//
//  ContactMethodView.swift
//  StayInTouch
//
//  Created by Michael Neas on 5/10/19.
//  Copyright © 2019 Michael Neas. All rights reserved.
//

import UIKit

protocol ContactMethodViewDelegate: class {
    func buttonTapped(_ sender: ContactContext)
    func viewSwiped(_ direction: UISwipeGestureRecognizer.Direction)
}

class ContactMethodView: UIView {
    
    weak var delegate: ContactMethodViewDelegate?
    
    lazy var smsButton: UIButton = {
        let smsButton = ContactMethodButton()
        smsButton.translatesAutoresizingMaskIntoConstraints = false
        return smsButton
    }()
    
    lazy var callButton: UIButton = {
        let callButton = ContactMethodButton()
        callButton.translatesAutoresizingMaskIntoConstraints = false
        return callButton
    }()
    
    lazy var facetimeButton: UIButton = {
        let facetimeButton = ContactMethodButton()
        facetimeButton.translatesAutoresizingMaskIntoConstraints = false
        return facetimeButton
    }()
    
    lazy var mailButton: UIButton = {
        let mailButton = ContactMethodButton()
        mailButton.translatesAutoresizingMaskIntoConstraints = false
        return mailButton
    }()
    
    lazy var buttonContentView: UIView = {
        let buttonContentView = UIView()
        //buttonContentView.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 0.5)
//        buttonContentView.layer.shadowColor = UIColor.gray.cgColor
//        buttonContentView.layer.shadowOffset = CGSize(width: 0, height: 10)
//        buttonContentView.layer.shadowOpacity = 1
//        buttonContentView.layer.shadowRadius = 5
        buttonContentView.addSubview(smsButton)
        buttonContentView.addSubview(callButton)
        buttonContentView.addSubview(facetimeButton)
        buttonContentView.addSubview(mailButton)
        buttonContentView.translatesAutoresizingMaskIntoConstraints = false
        return buttonContentView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(buttonContentView)
        setupLayout()
        setupGestureRecognizers()
        setupImages()
    }
    
    @objc private func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        var direction: CGAffineTransform = CGAffineTransform()
        switch gestureRecognizer.direction {
        case .left:
            direction = CGAffineTransform(translationX: -frame.width, y: 0)
        case .right:
            direction = CGAffineTransform(translationX: frame.width, y: 0)
        default:
            print("not implemented yet")
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.viewSwiped(gestureRecognizer.direction)
            strongSelf.transform = direction
        }, completion: nil)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // top left layout smsButton in buttonContentView
            smsButton.bottomAnchor.constraint(equalTo: buttonContentView.centerYAnchor, constant: -15),
            smsButton.trailingAnchor.constraint(equalTo: buttonContentView.centerXAnchor, constant: -10),
            smsButton.widthAnchor.constraint(equalToConstant: 100),
            smsButton.heightAnchor.constraint(equalToConstant: 100),
            
            // top right layout callButton in buttonContentView
            callButton.bottomAnchor.constraint(equalTo: buttonContentView.centerYAnchor, constant: -15),
            callButton.leadingAnchor.constraint(equalTo: buttonContentView.centerXAnchor, constant: 10),
            callButton.widthAnchor.constraint(equalToConstant: 100),
            callButton.heightAnchor.constraint(equalToConstant: 100),
            
            // bottom right layout facetimeButton in buttonContentView
            facetimeButton.topAnchor.constraint(equalTo: buttonContentView.centerYAnchor, constant: 15),
            facetimeButton.trailingAnchor.constraint(equalTo: buttonContentView.centerXAnchor, constant: -10),
            facetimeButton.widthAnchor.constraint(equalToConstant: 100),
            facetimeButton.heightAnchor.constraint(equalToConstant: 100),
            
            // bottom left layout mailButton in buttonContentView
            mailButton.topAnchor.constraint(equalTo: buttonContentView.centerYAnchor, constant: 15),
            mailButton.leadingAnchor.constraint(equalTo: buttonContentView.centerXAnchor, constant: 10),
            mailButton.widthAnchor.constraint(equalToConstant: 100),
            mailButton.heightAnchor.constraint(equalToConstant: 100),
            
            //buttonContentView
            buttonContentView.topAnchor.constraint(equalTo: topAnchor),
            buttonContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonContentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupGestureRecognizers() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        swipeLeftGesture.direction = .left
        addGestureRecognizer(swipeLeftGesture)
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        swipeRightGesture.direction = .right
        addGestureRecognizer(swipeRightGesture)
        
        [smsButton, callButton, facetimeButton, mailButton].forEach { button in
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            button.addGestureRecognizer(tap)
        }
    }
    
    private func setupImages() {
        smsButton.setImage(#imageLiteral(resourceName: "message"), for: .normal)
        callButton.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        facetimeButton.setImage(#imageLiteral(resourceName: "factime"), for: .normal)
        mailButton.setImage(#imageLiteral(resourceName: "mail"), for: .normal)
        
        [smsButton, callButton, facetimeButton, mailButton].forEach { button in
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        switch sender.view {
        case smsButton:
            delegate?.buttonTapped(.sms)
        case callButton:
            delegate?.buttonTapped(.phone)
        case facetimeButton:
            delegate?.buttonTapped(.facetime)
        case mailButton:
            delegate?.buttonTapped(.email)
        default:
            print("no gesture recognizer")
        }
        
    }
    
    //custom views should override this to return true if
    //they cannot layout correctly using autoresizing.
    //from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
