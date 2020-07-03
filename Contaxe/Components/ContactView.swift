//
//  ContactView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/15/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContactView: View {
    @Binding var contact: PhoneContact
    var connect: PhoneContacts
    
    func avatar() -> AnyView {
        if let avatar = contact.avatarData, let avatarImage = UIImage(data: avatar) {
            return AnyView(Image(uiImage: avatarImage)
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
                .frame(width: 200, height: 200, alignment: .top)
                .clipped()
            )
        } else {
            return AnyView(Text(contact.initials)
                .font(Font.system(size: 60, design: .default))
                .fontWeight(.bold)
                .padding(80.0)
                .background(Color.gray)
                .foregroundColor(.white)
            )
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            avatar()
                .clipShape(Circle())
                .padding(.top, 50.0)
            
            Spacer()
            
            VStack {
                Text(contact.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(contact.location)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }.padding()
            
            Spacer()
            
            VStack {
                HStack {
                    ContactButton(systemImage: "message", tapHandler: text)
                    ContactButton(systemImage: "phone", tapHandler: call)
                }.padding()
                HStack {
                    ContactButton(systemImage: "envelope", tapHandler: email)
                    ContactButton(systemImage: "video", tapHandler: faceTime)
                }.padding()
            }.padding(EdgeInsets(top: 10.0, leading: 36.0, bottom: 60.0, trailing: 36.0))
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.darkPurple, .cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.all)
        
    }
    
    func text() {
        guard let firstNumber = contact.phoneNumber.first else { print("No number"); return }
        connect.contact(phoneNumber: firstNumber, context: .sms)
    }
    
    func call() {
        // in simulator, this will not work, you need to test in device. The simulator doesn't have carrier service.
        guard let firstNumber = contact.phoneNumber.first else { print("No number"); return }
        connect.contact(phoneNumber: firstNumber, context: .phone)
    }
    
    func email() {
        guard let firstEmail = contact.email.first else { print("No email"); return }
        connect.contact(phoneNumber: firstEmail, context: .email)
    }
    
    func faceTime() {
        guard let firstNumber = contact.phoneNumber.first else { print("No number"); return }
        connect.contact(phoneNumber: firstNumber, context: .facetime)
    }
}
