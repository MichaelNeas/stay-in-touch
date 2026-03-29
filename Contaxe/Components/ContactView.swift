import SwiftUI

struct ContactView: View {
    let contact: PhoneContact
    var onText: (() -> Void)?
    var onCall: (() -> Void)?
    var onEmail: (() -> Void)?
    var onFaceTime: (() -> Void)?
    var onDelete: (() -> Void)?

    @State private var showDeleteConfirmation = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.darkPurple, .appCyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                avatarView
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                    .padding(.top, 60)
                    .accessibilityHidden(true)

                Spacer()

                VStack(spacing: 6) {
                    Text(contact.name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    if !contact.location.isEmpty {
                        Label(contact.location, systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .padding()
                .accessibilityElement(children: .combine)
                .accessibilityLabel(contact.location.isEmpty
                    ? contact.name
                    : "\(contact.name), \(contact.location)"
                )

                Spacer()

                VStack(spacing: 20) {
                    contactButtons
                    deleteButton
                }
                .padding(.bottom, 60)

                Spacer()
            }
        }
        .alert("Axe \(contact.name)?", isPresented: $showDeleteConfirmation) {
            Button("Axe", role: .destructive) { onDelete?() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete \(contact.name) from your phone.")
        }
    }

    @ViewBuilder
    private var avatarView: some View {
        if let data = contact.avatarData, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 180)
                .clipped()
        } else {
            Text(contact.initials)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .frame(width: 180, height: 180)
                .background(.white.opacity(0.2))
        }
    }

    @ViewBuilder
    private var contactButtons: some View {
        let hasPhone = !contact.phoneNumbers.isEmpty
        let hasEmail = !contact.emails.isEmpty

        if hasPhone {
            HStack(spacing: 24) {
                ContactButton(
                    systemImage: "message.fill", label: "Text",
                    accessibilityLabel: "Text \(contact.name)",
                    tapHandler: onText
                )
                ContactButton(
                    systemImage: "phone.fill", label: "Call",
                    accessibilityLabel: "Call \(contact.name)",
                    tapHandler: onCall
                )
                if hasEmail {
                    ContactButton(
                        systemImage: "envelope.fill", label: "Email",
                        accessibilityLabel: "Email \(contact.name)",
                        tapHandler: onEmail
                    )
                }
                ContactButton(
                    systemImage: "video.fill", label: "FaceTime",
                    accessibilityLabel: "FaceTime \(contact.name)",
                    tapHandler: onFaceTime
                )
            }
        } else if hasEmail {
            ContactButton(
                systemImage: "envelope.fill", label: "Email",
                accessibilityLabel: "Email \(contact.name)",
                tapHandler: onEmail
            )
        }
    }

    private var deleteButton: some View {
        Button(action: { showDeleteConfirmation = true }) {
            Label("Axe Contact", systemImage: "person.crop.circle.badge.xmark")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color(red: 1, green: 0.55, blue: 0.55))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
        }
        .accessibilityLabel("Axe \(contact.name)")
        .accessibilityHint("Permanently deletes this contact from your phone")
    }
}
