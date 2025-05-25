import SwiftUI
import PhotosUI

public struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingEditProfile = false
    @State private var showingSignOutAlert = false
    @State private var selectedItem: PhotosPickerItem?
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                // Sección de perfil
                Section {
                    HStack {
                        if let avatarUrl = authViewModel.userProfile?.avatarUrl {
                            AsyncImage(url: URL(string: avatarUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(authViewModel.userProfile?.fullName ?? "")
                                .font(.headline)
                            Text(authViewModel.userProfile?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Sección de suscripción
                Section("Suscripción") {
                    HStack {
                        Text("Estado")
                        Spacer()
                        Text(authViewModel.userProfile?.subscriptionStatus ?? "No activa")
                            .foregroundColor(.secondary)
                    }
                    
                    if let expiresAt = authViewModel.userProfile?.subscriptionExpiresAt {
                        HStack {
                            Text("Vence")
                            Spacer()
                            Text(expiresAt, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Lavados Restantes")
                        Spacer()
                        Text("\(authViewModel.userProfile?.remainingWashes ?? 0)")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Sección de acciones
                Section {
                    Button("Editar Perfil") {
                        showingEditProfile = true
                    }
                    
                    Button("Cerrar Sesión", role: .destructive) {
                        showingSignOutAlert = true
                    }
                }
            }
            .navigationTitle("Perfil")
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .alert("¿Cerrar sesión?", isPresented: $showingSignOutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    Task {
                        await authViewModel.signOut()
                    }
                }
            } message: {
                Text("¿Estás seguro de que quieres cerrar sesión?")
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fullName: String
    @State private var selectedItem: PhotosPickerItem?
    
    init() {
        _fullName = State(initialValue: authViewModel.userProfile?.fullName ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nombre completo", text: $fullName)
                }
                
                Section {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            Text("Cambiar Foto de Perfil")
                            Spacer()
                            Image(systemName: "photo")
                        }
                    }
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        Task {
                            await saveProfile()
                        }
                    }
                }
            }
        }
    }
    
    private func saveProfile() async {
        guard var profile = authViewModel.userProfile else { return }
        profile.fullName = fullName
        
        if let selectedItem = selectedItem,
           let data = try? await selectedItem.loadTransferable(type: Data.self) {
            do {
                let avatarUrl = try await SupabaseService.shared.uploadProfileImage(
                    userId: profile.id,
                    imageData: data
                )
                profile.avatarUrl = avatarUrl
            } catch {
                print("Error uploading image: \(error)")
            }
        }
        
        do {
            try await SupabaseService.shared.updateUserProfile(profile)
            authViewModel.userProfile = profile
            dismiss()
        } catch {
            print("Error updating profile: \(error)")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
} 