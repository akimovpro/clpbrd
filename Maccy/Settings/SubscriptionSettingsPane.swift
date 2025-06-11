import SwiftUI
import Defaults

struct SubscriptionSettingsPane: View {
  @State private var showSubscriptionView = false

  var body: some View {
    VStack(spacing: 15) {
      if Defaults[.isSubscribed] {
        Text("You are subscribed to ClipVista Pro!")
          .font(.headline)
        Button("Manage Subscription") {
          // Logic to open Stripe customer portal
        }
      } else if let trialEndDate = Defaults[.trialEndDate], Date() < trialEndDate {
        Text("You are on a free trial.")
          .font(.headline)
        Text("Trial ends on \(trialEndDate.formatted(date: .long, time: .shortened))")
        Button("Upgrade to Pro") {
          showSubscriptionView = true
        }
      } else {
        Text("You are on the free plan.")
          .font(.headline)
        Text("5 AI-powered copies per day.")
        Button("Upgrade to Pro") {
          showSubscriptionView = true
        }
      }
    }
    .sheet(isPresented: Binding(
      get: { showSubscriptionView },
      set: { showSubscriptionView = $0 }
    )) {
      SubscriptionView(isPresented: Binding(
        get: { showSubscriptionView },
        set: { showSubscriptionView = $0 }
      ), fromOnboarding: false)
    }
    .frame(width: 650, height: 200)
  }
}
