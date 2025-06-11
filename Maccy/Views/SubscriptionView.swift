import SwiftUI
import Defaults

struct SubscriptionView: View {
  @Binding var isPresented: Bool
  var fromOnboarding: Bool = false
  @State private var showPaymentView = false
  @State private var selectedPlan = ""

  var body: some View {
    VStack {
      if showPaymentView {
        PaymentView(plan: selectedPlan, onDone: {
          isPresented = false
        })
      } else {
        VStack(spacing: 20) {
          Image(systemName: "sparkles")
            .font(.system(size: 50))
            .foregroundColor(.accentColor)
          Text("Unlock ClipVista AI Pro")
            .font(.largeTitle)
          Text("Get unlimited access to all AI features.")
            .font(.title2)
            .multilineTextAlignment(.center)

          if fromOnboarding {
            Button(action: {
              Defaults[.trialEndDate] = Calendar.current.date(byAdding: .day, value: 7, to: Date())
              isPresented = false
            }) {
              Text("Start 1-Week Free Trial")
                .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
          }

          HStack(spacing: 20) {
            planButton(title: "Monthly", price: "$5/month", planId: "monthly")
            planButton(title: "Yearly", price: "$50/year", planId: "yearly", isPopular: true)
          }

          Spacer()

          Button(fromOnboarding ? "Activate Later" : "Maybe Later") {
            isPresented = false
          }
        }
        .padding(40)
      }
    }
    .frame(width: 500, height: fromOnboarding ? 600 : 400)
  }

  private func planButton(title: String, price: String, planId: String, isPopular: Bool = false) -> some View {
    Button(action: {
      selectedPlan = planId
      showPaymentView = true
    }) {
      VStack {
        if isPopular {
          Text("Most Popular")
            .font(.caption)
            .padding(2)
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(4)
        }
        Text(title).font(.headline)
        Text(price).font(.subheadline)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.secondary.opacity(0.2))
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(isPopular ? Color.accentColor : Color.clear, lineWidth: 2)
      )
    }
    .buttonStyle(.plain)
  }
}

struct PaymentView: View {
  var plan: String
  var onDone: () -> Void

  var body: some View {
    VStack(spacing: 20) {
      Text("Stripe Payment")
        .font(.largeTitle)
      Text("This is a placeholder for Stripe integration for the \(plan) plan.")
        .multilineTextAlignment(.center)
      ProgressView()
      Button("Simulate Successful Payment") {
        Defaults[.isSubscribed] = true
        onDone()
      }
      .controlSize(.large)
      Button("Cancel", action: onDone)
    }
    .padding(40)
    .frame(width: 500, height: 600)
  }
} 