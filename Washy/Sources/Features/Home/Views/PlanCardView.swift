
import SwiftUI

struct PlanCardView: View {
    let subscription: Subscription
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Plan Actual")
                .font(.headline)
            Text(subscription.status.capitalized)
                .foregroundColor(.gray)
            Text("Lavados restantes: \(subscription.washesRemaining)")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
