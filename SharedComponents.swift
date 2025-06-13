import SwiftUI

struct FeatureTile: View {
    var icon: String
    var title: String
    var description: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 40)
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(description).foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
} 