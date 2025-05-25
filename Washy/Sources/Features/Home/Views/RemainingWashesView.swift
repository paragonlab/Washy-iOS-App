
import SwiftUI

struct RemainingWashesView: View {
    let remainingWashes: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lavados Restantes")
                .font(.headline)
            Text("\(remainingWashes)")
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
