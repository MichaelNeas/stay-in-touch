import SwiftUI

struct SplashView: View {
    let onComplete: () -> Void

    @State private var opacity: Double = 0
    @State private var offsetY: CGFloat = 24

    var body: some View {
        ZStack {
            Color.splashPurple
                .ignoresSafeArea()

            VStack(spacing: 10) {
                // Drop your logo image here when ready:
                // Image("YourLogoName")
                //     .resizable()
                //     .scaledToFit()
                //     .frame(width: 120, height: 120)

                HStack(spacing: 0) {
                    Text("Cont")
                        .font(.system(size: 52, weight: .thin, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                    Text("AXE")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                Text("STAY CONNECTED")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                    .tracking(3)
            }
            .opacity(opacity)
            .offset(y: offsetY)
        }
        .onAppear { animate() }
    }

    private func animate() {
        withAnimation(.easeOut(duration: 0.7)) {
            opacity = 1
            offsetY = 0
        }

        withAnimation(.easeIn(duration: 0.4).delay(1.6)) {
            opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            onComplete()
        }
    }
}
