import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332), // Ciudad de México
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: viewModel.carWashes) { carWash in
                    MapAnnotation(coordinate: carWash.coordinate) {
                        CarWashAnnotationView(carWash: carWash)
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer()
                    
                    // Lista de autolavados cercanos
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.carWashes) { carWash in
                                CarWashCardView(carWash: carWash)
                            }
                        }
                        .padding()
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
            .navigationTitle("Autolavados")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.refreshLocation()
                    } label: {
                        Image(systemName: "location.fill")
                    }
                }
            }
        }
    }
}

struct CarWashAnnotationView: View {
    let carWash: CarWash
    
    var body: some View {
        VStack {
            Image(systemName: "car.fill")
                .foregroundColor(.blue)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(radius: 2)
            
            Text(carWash.name)
                .font(.caption)
                .padding(4)
                .background(Color.white)
                .cornerRadius(4)
        }
    }
}

struct CarWashCardView: View {
    let carWash: CarWash
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(carWash.name)
                .font(.headline)
            
            Text(carWash.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", carWash.rating))
            }
        }
        .padding()
        .frame(width: 200)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    MapView()
} 