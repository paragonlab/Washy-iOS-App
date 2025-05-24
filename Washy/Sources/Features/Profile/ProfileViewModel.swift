import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userName: String = "Usuario Ejemplo"
    @Published var userEmail: String = "usuario@ejemplo.com"
    @Published var currentPlan: SubscriptionPlan?
    @Published var washHistory: [WashHistory] = []
    
    init() {
        loadSampleData()
    }
    
    func refreshData() async {
        // TODO: Implementar llamada a la API
        loadSampleData()
    }
    
    func signOut() {
        // TODO: Implementar cierre de sesión
    }
    
    private func loadSampleData() {
        currentPlan = SubscriptionPlan(
            name: "Plan Básico",
            washesPerMonth: 4,
            price: 29.99
        )
        
        washHistory = [
            WashHistory(
                id: "1",
                carWashName: "AutoLavado Express",
                date: Date().addingTimeInterval(-86400) // Ayer
            ),
            WashHistory(
                id: "2",
                carWashName: "Lavado Premium",
                date: Date().addingTimeInterval(-172800) // Hace 2 días
            )
        ]
    }
}

struct WashHistory: Identifiable {
    let id: String
    let carWashName: String
    let date: Date
} 