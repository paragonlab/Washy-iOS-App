import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
            
            MapView()
                .tabItem {
                    Label("Mapa", systemImage: "map.fill")
                }
            
            QRView()
                .tabItem {
                    Label("QR", systemImage: "qrcode")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
} 