import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingEditProfile = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    if let profile = authViewModel.userProfile {
                        HStack {
                            if let avatarUrl = profile.avatarUrl {
                                AsyncImage(url: URL(string: avatarUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(profile.fullName)
                                    .font(.headline)
                                if let email = profile.email {
                                    Text(email)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                Section("Cuenta") {
                    Button(action: { showingEditProfile = true }) {
                        Label("Editar Perfil", systemImage: "person.crop.circle")
                    }
                    
                    Button(action: { showingLogoutAlert = true }) {
                        Label("Cerrar Sesión", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
                
                if let subscription = authViewModel.currentSubscription {
                    Section("Suscripción") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Plan Actual")
                                .font(.headline)
                            Text(subscription.status.capitalized)
                                .foregroundColor(.gray)
                            Text("Lavados restantes: \(subscription.washesRemaining)")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Perfil")
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .alert("¿Cerrar sesión?", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    Task {
                        await authViewModel.signOut()
                    }
                }
            } message: {
                Text("¿Estás seguro de que deseas cerrar sesión?")
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fullName: String = ""
    @State private var phone: String = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    @State private var error: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else if let profile = authViewModel.userProfile,
                                  let avatarUrl = profile.avatarUrl {
                            AsyncImage(url: URL(string: avatarUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    Button(action: { showingImagePicker = true }) {
                        Label("Cambiar Foto", systemImage: "photo")
                    }
                }
                
                Section("Información Personal") {
                    TextField("Nombre Completo", text: $fullName)
                    TextField("Teléfono", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                if let error = error {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task {
                            await saveProfile()
                        }
                    }
                    .disabled(isUploading)
                }
            }
            .onAppear {
                if let profile = authViewModel.userProfile {
                    fullName = profile.fullName
                    phone = profile.phone ?? ""
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .overlay {
                if isUploading {
                    ProgressView("Subiendo imagen...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
        }
    }
    
    private func saveProfile() async {
        guard var profile = authViewModel.userProfile else { return }
        isUploading = true
        error = nil
        
        do {
            if let image = selectedImage,
               let imageData = image.jpegData(compressionQuality: 0.8) {
                let avatarUrl = try await SupabaseService.shared.uploadProfileImage(
                    userId: profile.id,
                    imageData: imageData
                )
                profile.avatarUrl = avatarUrl
            }
            
            profile.fullName = fullName
            profile.phone = phone
            profile.updatedAt = Date()
            
            await authViewModel.updateUserProfile(profile)
            dismiss()
        } catch {
            self.error = error.localizedDescription
        }
        
        isUploading = false
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
} 