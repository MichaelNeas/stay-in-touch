//
//  ContactView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/15/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI
struct ContactView: View {
    @EnvironmentObject var phoneContactsViewModel: PhoneContactsViewModel
    
    func avatar() -> some View {
        if let avatar = phoneContactsViewModel.activeContact.avatarData, let avatarImage = UIImage(data: avatar) {
            return AnyView(
                Image(uiImage: avatarImage)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fill)
                    .frame(width: 200, height: 200, alignment: .top)
                    .clipped()
            )
        } else {
            return AnyView(
                Text(phoneContactsViewModel.activeContact.initials)
                    .font(.system(size: 60, design: .default))
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
                Text(phoneContactsViewModel.activeContact.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                if !phoneContactsViewModel.activeContact.location.isEmpty {
                    Text(phoneContactsViewModel.activeContact.location)
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

            if !phoneContactsViewModel.activeContact.emails.isEmpty && phoneContactsViewModel.activeContact.phoneNumbers.isEmpty {
                
                AnyView(VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ContactButton(systemImage: "envelope", tapHandler: phoneContactsViewModel.email)
                        Spacer()
                    }
                    Spacer()
                })
            } else {
                // Show all contact options (message, phone, email, and FaceTime)
                AnyView(VStack {
                    HStack {
                        Spacer()
                        ContactButton(systemImage: "message", tapHandler: phoneContactsViewModel.text)
                        Spacer()
                        ContactButton(systemImage: "phone", tapHandler: phoneContactsViewModel.call)
                        Spacer()
                    }.padding()
                    HStack {
                        if let firstEmail = phoneContactsViewModel.activeContact.emails.first, !firstEmail.isEmpty {
                            Spacer()
                            ContactButton(systemImage: "envelope", tapHandler: phoneContactsViewModel.email)
                        }
                        Spacer()
                        if !phoneContactsViewModel.activeContact.phoneNumbers.isEmpty {
                            ContactButton(systemImage: "video", tapHandler: phoneContactsViewModel.faceTime)
                        }
                        Spacer()
                    }.padding()
                })
            }
        }
    
}
