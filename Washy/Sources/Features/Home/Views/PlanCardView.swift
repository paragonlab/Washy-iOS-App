import SwiftUI

struct PlanCardView: View {
    let subscription: Subscription
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Plan Actual")
                .font(.headline)
            
            Text(subscription.status.capitalized)
                .foregroundColor(.gray)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Lavados restantes")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(subscription.washesRemaining)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Válido hasta")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(subscription.currentPeriodEnd, style: .date)
                        .font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
