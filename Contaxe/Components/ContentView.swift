import SwiftUI

struct ContentView: View {
    @Environment(PhoneContactsViewModel.self) private var viewModel
    @State private var showSettings = false

    var body: some View {
        ZStack {
            if showSettings {
                SettingsView(isPresented: $showSettings)
                    .transition(.move(edge: .trailing))
            } else {
                mainContent
            }
        }
        .animation(.easeInOut, value: showSettings)
    }

    @ViewBuilder
    private var mainContent: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.permissionDenied {
            permissionDeniedView
        } else if let contact = viewModel.activeContact {
            ContactView(
                contact: contact,
                onText: viewModel.text,
                onCall: viewModel.call,
                onEmail: viewModel.email,
                onFaceTime: viewModel.faceTime,
                onDelete: { Task { await viewModel.deleteActiveContact() } }
            )
            overlayButtons
        } else {
            emptyView
        }
    }

    private var overlayButtons: some View {
        VStack {
            HStack {
                #if DEBUG
                TopBarButton(imageName: "arrow.clockwise", color: .white, label: "Next contact") {
                    viewModel.nextContact()
                }
                #endif

                Spacer()

                TopBarButton(
                    imageName: "gearshape",
                    color: .white,
                    label: "Settings",
                    hint: "Open notification and app settings"
                ) {
                    withAnimation { showSettings = true }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            Spacer()
        }
    }

    private var loadingView: some View {
        ZStack {
            LinearGradient(colors: [.darkPurple, .appCyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ProgressView()
                .tint(.white)
                .scaleEffect(1.5)
        }
    }

    private var permissionDeniedView: some View {
        ZStack {
            LinearGradient(colors: [.darkPurple, .appCyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle.badge.xmark")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                Text("Contacts Access Required")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text("Please enable contacts access in Settings to use this app.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(Color.darkPurple)
            }
        }
    }

    private var emptyView: some View {
        ZStack {
            LinearGradient(colors: [.darkPurple, .appCyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                Text("No Contacts")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
        }
    }
}

struct TopBarButton: View {
    let imageName: String
    let color: Color
    let label: String
    var hint: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 50, height: 50)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .accessibilityLabel(label)
        .accessibilityHint(hint ?? "")
    }
}
