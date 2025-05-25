
import SwiftUI

struct FeaturedOffersView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ofertas Destacadas")
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
import SwiftUI

struct FeaturedOffersView: View {
    let offers: [String] // Placeholder, replace with proper Offer model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ofertas Destacadas")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(offers, id: \.self) { offer in
                        Text(offer)
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
