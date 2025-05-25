import Foundation
import Supabase
// Las definiciones de modelos ahora están en Models.swift
// struct UserProfile: Codable { ... }
// struct Subscription: Codable { ... }
// struct WashHistory: Codable, Identifiable { ... }
// struct CarWash: Codable, Identifiable { ... }
// struct Plan: Identifiable { ... } // Si este modelo se definió aquí

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile? // Usar el modelo de Models.swift
    @Published var currentSubscription: Subscription? // Usar el modelo de Models.swift
    @Published var washHistory: [WashHistory] = [] // Usar el modelo de Models.swift
    // @Published var currentPlan: Plan? // Usar el modelo de Models.swift si se definió
    @Published var isLoading = false
    @Published var error: String? // Agregar manejo de errores
    
    private let supabaseService = SupabaseService.shared
    
    func refreshData() async {
        isLoading = true
        error = nil // Limpiar errores anteriores
        defer { isLoading = false }
        
        do {
            // Obtener el usuario actual y luego su perfil, suscripción e historial
            if let user = try await supabaseService.getCurrentUser() {
                // Asegurarse de que los servicios devuelvan los modelos correctos de Models.swift
                self.userProfile = try await supabaseService.getUserProfile(userId: user.id)
                self.currentSubscription = try await supabaseService.getCurrentSubscription(userId: user.id)
                self.washHistory = try await supabaseService.getWashHistory(userId: user.id)
                
                // Si tenías lógica para obtener el plan, adaptarla aquí
                // self.currentPlan = try await supabaseService.getCurrentPlan(userId: user.id)
                
            } else {
                // Usuario no autenticado, limpiar datos
                self.userProfile = nil
                self.currentSubscription = nil
                self.washHistory = []
                // self.currentPlan = nil
            }
            
        } catch {
            self.error = error.localizedDescription // Capturar y mostrar errores
        }
    }
    
    // Eliminar la función signOut de aquí, ya se maneja en AuthViewModel
    // func signOut() { ... }
}

// Eliminar la definición duplicada de WashHistory de aquí
// struct WashHistory: Identifiable {
//     let id: String
//     let carWashName: String
//     let date: Date
// } 