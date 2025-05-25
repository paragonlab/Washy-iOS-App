import SwiftUI

public struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingWashHistory = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Tarjeta de suscripción
                    SubscriptionCard(
                        remainingWashes: authViewModel.userProfile?.remainingWashes ?? 0,
                        subscriptionStatus: authViewModel.userProfile?.subscriptionStatus ?? "No activa"
                    )
                    
                    // Botón de lavado
                    Button {
                        // Acción para iniciar un lavado
                    } label: {
                        HStack {
                            Image(systemName: "drop.fill")
                            Text("Iniciar Lavado")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Historial de lavados
                    Button {
                        showingWashHistory = true
                    } label: {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Historial de Lavados")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Inicio")
            .sheet(isPresented: $showingWashHistory) {
                WashHistoryView()
            }
        }
    }
}

struct SubscriptionCard: View {
    let remainingWashes: Int
    let subscriptionStatus: String
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Tu Suscripción")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Lavados Restantes")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(remainingWashes)")
                        .font(.title)
                        .bold()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Estado")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(subscriptionStatus)
                        .font(.title3)
                        .bold()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
} 