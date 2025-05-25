import SwiftUI

struct FeaturedOffersView: View {
    let offers: [Offer]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ofertas Destacadas")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(offers) { offer in
                        VStack(alignment: .leading) {
                            Text(offer.title)
                                .font(.headline)
                            Text(offer.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.2f", offer.price))")
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