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
                    }
                    
                    // Lavados restantes
                    RemainingWashesView(count: viewModel.remainingWashes)
                    
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