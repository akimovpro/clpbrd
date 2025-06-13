import SwiftUI
import Defaults

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var showOnboarding = !Defaults[.onboardingCompleted]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Onboarding Settings")
                .font(.title)
                .fontWeight(.bold)
            
            Toggle("Show Onboarding", isOn: $showOnboarding)
                .onChange(of: showOnboarding) { _, newValue in
                    Defaults[.onboardingCompleted] = !newValue
                }
            
            Text("Control whether to show the onboarding experience when launching the app.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 300)
    }
} 