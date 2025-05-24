import SwiftUI

struct QRView: View {
    @StateObject private var viewModel = QRViewModel()
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let qrImage = viewModel.qrImage {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                } else {
                    ProgressView()
                        .frame(width: 250, height: 250)
                }
                
                Text("Muestra este código QR en el autolavado")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if viewModel.isCarWashUser {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Escanear QR", systemImage: "qrcode.viewfinder")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Mi QR")
            .sheet(isPresented: $isShowingScanner) {
                QRScannerView { result in
                    viewModel.handleScannedCode(result)
                }
            }
        }
    }
}

struct QRScannerView: UIViewControllerRepresentable {
    let completion: (String) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        // TODO: Implementar escáner de QR
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

#Preview {
    QRView()
} 