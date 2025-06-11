import SwiftUI
import Defaults

struct OnboardingView: View {
  @Binding var isPresented: Bool
  @State private var step: OnboardingStep = .intro

  enum OnboardingStep {
    case intro, activities, pricing
  }

  var body: some View {
    VStack {
      switch step {
      case .intro:
        OnboardingIntroView(onContinue: { step = .activities })
      case .activities:
        OnboardingActivitiesView(onContinue: { step = .pricing })
      case .pricing:
        SubscriptionView(isPresented: $isPresented, fromOnboarding: true)
      }
    }
    .frame(width: 500, height: 600)
    .onDisappear {
      Defaults[.onboardingCompleted] = true
    }
  }
}

struct OnboardingIntroView: View {
  var onContinue: () -> Void

  var body: some View {
    VStack(spacing: 20) {
      Text("Welcome to ClipVista AI")
        .font(.largeTitle)
      Text("Supercharge your clipboard with AI.")
        .font(.title2)
      VStack(alignment: .leading, spacing: 15) {
        Label("Translate text instantly", systemImage: "globe")
        Label("Check spelling and grammar", systemImage: "text.badge.checkmark")
        Label("Summarize long articles", systemImage: "doc.text.magnifyingglass")
        Label("And much more...", systemImage: "sparkles")
      }
      .padding()
      Spacer()
      Button(action: onContinue) {
        Text("Continue")
          .frame(maxWidth: .infinity)
      }
      .controlSize(.large)
    }
    .padding(40)
  }
}

struct OnboardingActivitiesView: View {
  var onContinue: () -> Void

  private let activities = [
    "Translation", "Spell checking", "Summary", "Simplify language",
    "Extract action items", "Adjust tone", "Expand on a point", "Extract entities",
    "Draft a reply", "Generate a headline", "Convert to markdown",
    "Create social media post", "Brainstorm ideas", "Add a relevant emoji"
  ]
  @State private var selectedActivities: Set<String> = []
  @State private var customActivity: String = ""

  private var canContinue: Bool {
    selectedActivities.count + (customActivity.isEmpty ? 0 : 1) >= 10
  }

  private let columns = [
    GridItem(.adaptive(minimum: 150))
  ]

  var body: some View {
    VStack(spacing: 20) {
      Text("What do you want to do?")
        .font(.largeTitle)
      Text("Select at least 10 activities to continue.")
        .font(.title2)

      ScrollView {
        LazyVGrid(columns: columns, spacing: 10) {
          ForEach(activities, id: \.self) { activity in
            Button(action: {
              if selectedActivities.contains(activity) {
                selectedActivities.remove(activity)
              } else {
                selectedActivities.insert(activity)
              }
            }) {
              Text(activity)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(selectedActivities.contains(activity) ? Color.accentColor : Color.secondary.opacity(0.2))
                .foregroundColor(selectedActivities.contains(activity) ? .white : .primary)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
          }
        }
      }

      TextField("Custom prompt...", text: $customActivity)
        .textFieldStyle(.roundedBorder)

      Spacer()

      Button(action: onContinue) {
        Text("Continue")
          .frame(maxWidth: .infinity)
      }
      .controlSize(.large)
      .disabled(!canContinue)
    }
    .padding(40)
  }
} 