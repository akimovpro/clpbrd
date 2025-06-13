import SwiftUI

struct OnboardingAboutYouView: View {
    @Binding var role: String
    @Binding var dayToDay: String
    
    private let roles = [
        "Designer",
        "Developer",
        "Writer",
        "Student",
        "Researcher",
        "Other"
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Tell us about yourself")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What best describes your role?")
                        .font(.headline)
                    
                    Picker("Role", selection: $role) {
                        ForEach(roles, id: \.self) { role in
                            Text(role).tag(role)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("What do you do day-to-day?")
                        .font(.headline)
                    
                    TextEditor(text: $dayToDay)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("Tell us about your typical tasks and activities (minimum 50 characters)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: 500)
        }
        .padding()
    }
}

#Preview {
    OnboardingAboutYouView(
        role: .constant("Designer"),
        dayToDay: .constant("")
    )
} 