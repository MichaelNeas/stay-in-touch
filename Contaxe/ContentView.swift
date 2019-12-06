//
//  ContentView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContentView: View {
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
    
    var body: some View {
        VStack {
            Spacer(minLength: 100.0)
            
            Text("DH")
                .font(Font.system(size: 60, design: .default))
                .fontWeight(.bold)
                .padding(80.0)
                .background(Color.gray)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding(.bottom, 40.0)

            
            VStack {
                Text("Dana Higgins")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Boston, MA")
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
    
    func tapped(_ number: Int) {
        print(number)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
