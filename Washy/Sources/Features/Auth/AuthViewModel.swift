import Foundation
// Las definiciones de modelos ahora están en Models.swift
// struct User: Codable { ... }
// struct UserProfile: Codable { ... }
// struct Subscription: Codable { ... }

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var userProfile: UserProfile?
    @Published var currentSubscription: Subscription?
    @Published var error: String?
    @Published var isLoading = false

    private let supabaseService = SupabaseService.shared

    init() {
        Task {
            await checkAuthStatus()
        }
    }

    func checkAuthStatus() async {
        isLoading = true
        defer { isLoading = false }

        do {
            if let user = try await supabaseService.getCurrentUser() {
                currentUser = user
                // Asegurarse de que getUserProfile y getCurrentSubscription devuelvan los modelos correctos
                userProfile = try await supabaseService.getUserProfile(userId: user.id)
                currentSubscription = try await supabaseService.getCurrentSubscription(userId: user.id)
                isAuthenticated = true
            } else {
                isAuthenticated = false
                currentUser = Optional<User>.none
                userProfile = Optional<UserProfile>.none
                currentSubscription = Optional<Subscription>.none
            }
        } catch {
            self.error = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let user = try await supabaseService.signIn(email: email, password: password)
            currentUser = user
            userProfile = try await supabaseService.getUserProfile(userId: user.id)
            currentSubscription = try await supabaseService.getCurrentSubscription(userId: user.id)
            isAuthenticated = true
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }

    func signUp(email: String, password: String, fullName: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let user = try await supabaseService.signUp(email: email, password: password)
            currentUser = user

            let profile = UserProfile(
                id: user.id,
                fullName: fullName,
                email: email,
                phone: nil,
                avatarUrl: nil,
                createdAt: Date(),
                updatedAt: Date()
            )

            try await supabaseService.createUserProfile(profile)
            userProfile = profile
            isAuthenticated = true
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }

    func signOut() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await supabaseService.signOut()
            isAuthenticated = false
            currentUser = Optional<User>.none
            userProfile = Optional<UserProfile>.none
            currentSubscription = Optional<Subscription>.none
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }

    func updateUserProfile(_ profile: UserProfile) async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await supabaseService.updateUserProfile(profile)
            userProfile = profile
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }
}