
import SwiftUI

struct StorePreviewView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tienda")
                .font(.headline)
            Text("Próximamente")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
