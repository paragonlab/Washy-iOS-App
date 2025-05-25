import SwiftUI

struct PlanCardView: View {
    var plan: Plan?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Plan Actual")
                .font(.headline)
            if let plan = plan {
                Text(plan.name)
                    .font(.title2)
            } else {
                Text("Sin plan activo")
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct RemainingWashesView: View {
    var count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lavados Restantes")
                .font(.headline)
            Text("\(count)")
                .font(.title)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Plan actual
                    PlanCardView(plan: viewModel.currentPlan)
                    
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