import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.userName)
                                .font(.headline)
                            Text(viewModel.userEmail)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Mi Plan") {
                    if let plan = viewModel.currentPlan {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(plan.name)
                                .font(.headline)
                            Text("\(plan.washesPerMonth) lavados por mes")
                            Text("$\(String(format: "%.2f", plan.price))")
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section("Historial") {
                    ForEach(viewModel.washHistory) { wash in
                        WashHistoryRow(wash: wash)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.signOut()
                    } label: {
                        HStack {
                            Text("Cerrar Sesión")
                            Spacer()
                            Image(systemName: "arrow.right.square")
                        }
                    }
                }
            }
            .navigationTitle("Perfil")
            .refreshable {
                await viewModel.refreshData()
            }
        }
    }
}

struct WashHistoryRow: View {
    let wash: WashHistory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(wash.carWashName)
                .font(.headline)
            Text(wash.date.formatted(date: .abbreviated, time: .shortened))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProfileView()
} 