
import SwiftUI

struct PlanCardView: View {
    let plan: SubscriptionPlan?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(plan?.name ?? "Sin plan")
                .font(.title2)
                .bold()
            if let plan = plan {
                Text("\(plan.washesPerMonth) lavados por mes")
                Text("$\(String(format: "%.2f", plan.price))")
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
