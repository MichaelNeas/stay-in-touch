//
//  ContentView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack {
            Circle()
                .fill(Color.green)
            
            VStack {
                Text("Dana Higgins")
                    .font(.title)
                Text("Boston, MA")
            }.padding()
            
            
            VStack {
                HStack {
//                    Button(action: {
//                        self.tapped(1)
//                    }) {
//                        Image().renderingMode(.original)
//                            .clipShape(Circle())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
//                    }.padding()
                    Circle()
                }
                HStack {
                    Circle()
                    Circle()
                }
            }
            
        }.padding()
    }
    
    func tapped(_ number: Int) {
        print(number)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
