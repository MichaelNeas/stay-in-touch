//
//  ContactView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/15/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContactView: View {
    var contact: PhoneContact
    
    func avatar() -> AnyView {
        if let avatar = contact.avatarData {
            return AnyView(Image(uiImage: UIImage(data: avatar)!))
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
            Spacer(minLength: 80.0)
            avatar().clipShape(Circle()).padding(.bottom, 40.0)
            VStack {
                Text(contact.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(contact.location)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }.padding()
            
            VStack {
                HStack {
                    ContactButton(systemImage: "message")
                    ContactButton(systemImage: "phone")
                }.padding()
                HStack {
                    ContactButton(systemImage: "envelope")
                    ContactButton(systemImage: "video")
                }.padding()
            }.padding(EdgeInsets(top: 10.0, leading: 36.0, bottom: 60.0, trailing: 36.0))
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.darkPurple, .cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contact: PhoneContact())
    }
}
