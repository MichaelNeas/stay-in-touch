//
//  ContactButton.swift
//  Contaxe
//
//  Created by Michael Neas on 12/15/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContactButton: View {
    var systemImage: String
    
    var body: some View {
        Button(action: {
            print("tapped")
        }) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(36.0)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}

struct ContactButton_Previews: PreviewProvider {
    static var previews: some View {
        ContactButton(systemImage: "message").background(Color.black)
    }
}

