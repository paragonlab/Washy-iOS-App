import SwiftUI

struct StorePreviewView: View {
    let products: [Product]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tienda")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text("$\(String(format: "%.2f", product.price))")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
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