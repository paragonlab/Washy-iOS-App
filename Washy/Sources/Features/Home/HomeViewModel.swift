import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentSubscription: Subscription?
    @Published var remainingWashes: Int = 0
    @Published var featuredOffers: [Offer] = []
    @Published var featuredProducts: [Product] = []
    
    private let supabaseService = SupabaseService.shared
    
    func refreshData() async {
        do {
            if let user = try await supabaseService.getCurrentUser() {
                currentSubscription = try await supabaseService.getCurrentSubscription(userId: user.id)
                remainingWashes = currentSubscription?.washesRemaining ?? 0
            }
            
            // TODO: Implementar llamadas a la API para ofertas y productos
            // Por ahora usamos datos de ejemplo
            featuredOffers = [
                Offer(title: "Lavado Premium", description: "Lavado completo + cera", price: 19.99),
                Offer(title: "Combo Interior", description: "Limpieza interior completa", price: 24.99)
            ]
            featuredProducts = [
                Product(name: "Cera Premium", price: 29.99),
                Product(name: "Kit Limpieza", price: 39.99)
            ]
        } catch {
            print("Error al refrescar datos: \(error)")
        }
    }
}

// Modelos temporales para la UI
struct Offer: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let price: Double
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
} 