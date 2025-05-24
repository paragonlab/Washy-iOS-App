import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentPlan: SubscriptionPlan?
    @Published var remainingWashes: Int = 0
    @Published var featuredOffers: [Offer] = []
    @Published var featuredProducts: [Product] = []
    
    func refreshData() async {
        // TODO: Implementar llamadas a la API
        // Por ahora usamos datos de ejemplo
        currentPlan = SubscriptionPlan(
            name: "Plan Básico",
            washesPerMonth: 4,
            price: 29.99
        )
        remainingWashes = 3
        featuredOffers = [
            Offer(title: "Lavado Premium", description: "Lavado completo + cera", price: 19.99),
            Offer(title: "Combo Interior", description: "Limpieza interior completa", price: 24.99)
        ]
        featuredProducts = [
            Product(name: "Cera Premium", price: 29.99),
            Product(name: "Kit Limpieza", price: 39.99)
        ]
    }
}

// Modelos temporales
struct SubscriptionPlan {
    let name: String
    let washesPerMonth: Int
    let price: Double
}

struct Offer {
    let title: String
    let description: String
    let price: Double
}

struct Product {
    let name: String
    let price: Double
} 