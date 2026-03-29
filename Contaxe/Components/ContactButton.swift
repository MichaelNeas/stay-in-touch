import SwiftUI

struct ContactButton: View {
    let systemImage: String
    let label: String
    var accessibilityLabel: String? = nil
    var tapHandler: (() -> Void)?

    var body: some View {
        Button(action: { tapHandler?() }) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 60)
                    .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 1.5))
                Text(label)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .accessibilityLabel(accessibilityLabel ?? label)
    }
}

#Preview {
    HStack(spacing: 24) {
        ContactButton(systemImage: "message.fill", label: "Text")
        ContactButton(systemImage: "phone.fill", label: "Call")
        ContactButton(systemImage: "envelope.fill", label: "Email")
        ContactButton(systemImage: "video.fill", label: "FaceTime")
    }
    .padding()
    .background(Color.darkPurple)
}
