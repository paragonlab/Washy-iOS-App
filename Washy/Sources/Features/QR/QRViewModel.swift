import Foundation
import UIKit

@MainActor
class QRViewModel: ObservableObject {
    @Published var qrImage: UIImage?
    @Published var isCarWashUser: Bool = false
    
    init() {
        generateQR()
    }
    
    private func generateQR() {
        // TODO: Implementar generación de QR con datos del usuario
        // Por ahora usamos un QR de ejemplo
        let data = "washy:user:123".data(using: .utf8)!
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("M", forKey: "inputCorrectionLevel")
            
            if let ciImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 10, y: 10)
                let scaledCIImage = ciImage.transformed(by: transform)
                qrImage = UIImage(ciImage: scaledCIImage)
            }
        }
    }
    
    func handleScannedCode(_ code: String) {
        // TODO: Implementar validación y procesamiento del código QR escaneado
        print("Código escaneado: \(code)")
    }
} 