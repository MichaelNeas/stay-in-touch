//
//  ContactView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/15/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContactView: View {
    @ObservedObject var connect: PhoneContacts
    
    func avatar() -> AnyView {
        if let avatar = connect.activeContact.avatarData, let avatarImage = UIImage(data: avatar) {
            return AnyView(Image(uiImage: avatarImage)
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
                .frame(width: 200, height: 200, alignment: .top)
                .clipped()
            )
        } else {
            return AnyView(Text(connect.activeContact.initials)
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
                Text(connect.activeContact.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                if !connect.activeContact.location.isEmpty {
                    Text(connect.activeContact.location)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }.padding()
            
            Spacer()
            contactMethods
            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.darkPurple, .cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.all)
        
    }
    
    var contactMethods: some View {
        if !connect.activeContact.email.isEmpty && connect.activeContact.phoneNumber.isEmpty {
            return AnyView(VStack {
                Spacer()
                HStack {
                    Spacer()
                    ContactButton(systemImage: "envelope", tapHandler: email)
                    Spacer()
                }
                Spacer()
            })
        } else {
            return AnyView(VStack {
                HStack {
                    Spacer()
                    ContactButton(systemImage: "message", tapHandler: text)
                    Spacer()
                    ContactButton(systemImage: "phone", tapHandler: call)
                    Spacer()
                }.padding()
                HStack {
                    if !connect.activeContact.email.isEmpty {
                        Spacer()
                        ContactButton(systemImage: "envelope", tapHandler: email)
                    }
                    Spacer()
                    ContactButton(systemImage: "video", tapHandler: faceTime)
                    Spacer()
                }.padding()
            })
        }
    }
    
    func text() {
        guard let firstNumber = connect.activeContact.phoneNumber.first else { print("No number"); return }
        connect.contact(phoneNumber: firstNumber, context: .sms)
    }
    
    func call() {
        // in simulator, this will not work, you need to test in device. The simulator doesn't have carrier service.
        guard let firstNumber = connect.activeContact.phoneNumber.first else { print("No number"); return }
        connect.contact(phoneNumber: firstNumber, context: .phone)
    }
    
    func email() {
        guard let firstEmail = connect.activeContact.email.first else { print("No email"); return }
        connect.contact(phoneNumber: firstEmail, context: .email)
    }
    
    func faceTime() {
        guard let firstNumber = connect.activeContact.phoneNumber.first else { print("No number"); return }
        connect.contact(phoneNumber: firstNumber, context: .facetime)
    }
}
