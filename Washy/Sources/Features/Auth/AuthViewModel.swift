import Foundation
import SwiftUI

public class AuthViewModel: ObservableObject {
    @Published public var isAuthenticated = false
    @Published public var isLoading = false
    @Published public var error: String?
    @Published public var userProfile: UserProfile?
    
    public init() {}
    
    public func signIn(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            let user = try await SupabaseService.shared.signIn(email: email, password: password)
            let profile = try await SupabaseService.shared.getUserProfile(userId: user.id)
            let subscription = try await SupabaseService.shared.getCurrentSubscription(userId: user.id)
            
            DispatchQueue.main.async {
                self.userProfile = profile
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    public func signUp(email: String, password: String, fullName: String) async {
        isLoading = true
        error = nil
        
        do {
            let user = try await SupabaseService.shared.signUp(email: email, password: password)
            let profile = UserProfile(
                id: user.id,
                fullName: fullName,
                email: email,
                phone: user.phone,
                avatarUrl: nil,
                subscriptionId: nil,
                subscriptionStatus: nil,
                subscriptionExpiresAt: nil,
                remainingWashes: 0
            )
            
            try await SupabaseService.shared.createUserProfile(profile)
            
            DispatchQueue.main.async {
                self.userProfile = profile
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    public func signOut() async {
        do {
            try await SupabaseService.shared.signOut()
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.userProfile = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
            }
        }
    }
    
    public func checkAuthStatus() async {
        do {
            if let user = try await SupabaseService.shared.getCurrentUser() {
                let profile = try await SupabaseService.shared.getUserProfile(userId: user.id)
                DispatchQueue.main.async {
                    self.userProfile = profile
                    self.isAuthenticated = true
                }
            }
        } catch {
            print("Error checking auth status: \(error)")
        }
    }
}