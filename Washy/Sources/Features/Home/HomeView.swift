import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Plan actual
                    PlanCardView(subscription: viewModel.currentSubscription)
                    
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