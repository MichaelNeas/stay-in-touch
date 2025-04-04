//
//  ContentView.swift
//  Contaxe
//
//  Created by Michael Neas on 12/4/19.
//  Copyright © 2019 Neas Lease. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var notifications = Notifications()
    @ObservedObject var settings = Settings()
    @State var showSettings: Bool = false
    @State private var showDeleteConfirmation = false

    @EnvironmentObject var phoneContactsViewModel: PhoneContactsViewModel
    
    var body: some View {
        ZStack {
            if showSettings {
                SettingsView(presented: $showSettings, notifications: notifications, settings: settings)
                    .transition(.move(edge: .trailing))
            } else {
                ContactView()
                topBar
            }
        }
        .animation(.easeInOut, value: showSettings)
    }

    var topBar: some View {
        VStack {
            HStack {
                #if DEBUG
                TopBarButton(imageName: "arrow.clockwise.circle", action: {
                    phoneContactsViewModel.newActiveContact()
                }, color: .gray)
                #endif

                TopBarButton(imageName: "trash", action: {
                    showDeleteConfirmation = true
                }, color: .red)

                Spacer()

                TopBarButton(imageName: "gear", action: {
                    withAnimation { showSettings = true }
                }, color: .gray)
            }
            .padding()
            Spacer()
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("This will permanently delete the contact."),
                primaryButton: .destructive(Text("Delete")) {
                    phoneContactsViewModel.deleteContact()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct TopBarButton: View {
    let imageName: String
    let action: () -> Void
    let color: Color
    
    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.system(size: 36, weight: .thin))
                .foregroundColor(color)
        }
    }
}
