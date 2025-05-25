import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Mapa", systemImage: "map")
                }
            
            QRView()
                .tabItem {
                    Label("QR", systemImage: "qrcode")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
} 