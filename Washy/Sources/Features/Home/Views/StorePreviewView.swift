import SwiftUI

struct StorePreviewView: View {
    let products: [String] // Placeholder, replace with proper Product model

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tienda")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products, id: \.self) { product in
                        Text(product)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
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