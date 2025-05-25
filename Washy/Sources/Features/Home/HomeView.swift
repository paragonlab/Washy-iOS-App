import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Plan actual
                    if let subscription = viewModel.currentSubscription {
                        PlanCardView(subscription: subscription)
                    } else {
                        Text("No tienes un plan activo")
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                    }
                    
                    // Lavados restantes
                    RemainingWashesView(remainingWashes: viewModel.remainingWashes)
                    
                    // Ofertas destacadas
                    FeaturedOffersView(offers: viewModel.featuredOffers)
                    
                    // Tienda
                    StorePreviewView(products: viewModel.featuredProducts)
                }
                .padding()
            }
            .navigationTitle("Washy")
            .refreshable {
                await viewModel.refreshData()
            }
        }
    }
}

#Preview {
    HomeView()
} 