import SwiftUI

@main
struct ContaxeApp: App {
    @State private var settings = Settings()
    @State private var notifications = Notifications()
    @State private var viewModel = PhoneContactsViewModel(
        contactService: PhoneContactsService(),
        actionsService: ContactsActionsService()
    )

    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(settings)
                    .environment(notifications)
                    .environment(viewModel)
                if showSplash {
                    SplashView {
                        withAnimation(.easeOut(duration: 0.4)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.4), value: showSplash)
        }
    }
}
