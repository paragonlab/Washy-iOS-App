import Foundation
import SwiftUI

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
                userProfile = try await supabaseService.getUserProfile(userId: user.id)
                currentSubscription = try await supabaseService.getCurrentSubscription(userId: user.id)
                isAuthenticated = true
            } else {
                isAuthenticated = false
                currentUser = nil
                userProfile = nil
                currentSubscription = nil
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
            userProfile = try await supabaseService.getUserProfile(userId: String(user.id))
            currentSubscription = try await supabaseService.getCurrentSubscription(userId: String(user.id))
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
                id: String(user.id),
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
            currentUser = nil
            userProfile = nil
            currentSubscription = nil
            error = nil
        } catch {
            self.error = error.localizedDescription
        }
    }
}