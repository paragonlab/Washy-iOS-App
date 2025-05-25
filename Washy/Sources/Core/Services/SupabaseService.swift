import Foundation
import CoreLocation
import Supabase

// Importar los modelos definidos en Models.swift
@_exported import struct Washy.User
@_exported import struct Washy.UserProfile
@_exported import struct Washy.Subscription
@_exported import struct Washy.CarWash
@_exported import struct Washy.WashHistory

class SupabaseService {
    static let shared = SupabaseService()

    private let client: SupabaseClient

    private init() {
        let supabaseURL = URL(string: "https://hrwqcsiwvudixifdwtoi.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhyd3Fjc2l3dnVkaXhpZmR3dG9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxMTI5MTIsImV4cCI6MjA2MzY4ODkxMn0.RDwT740wGQUxGWOz9XgqPtUC_1lBQjDUT9RDPReJKtQ"

        client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }

    // MARK: - Autenticación

    func signUp(email: String, password: String) async throws -> User {
        let response = try await client.auth.signUp(email: email, password: password)
        guard let user = response.user else {
            throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found after sign up"])
        }
        return User(id: user.id.uuidString, email: user.email, phone: user.phone)
    }

    func signIn(email: String, password: String) async throws -> User {
        let response = try await client.auth.signIn(email: email, password: password)
         guard let user = response.user else {
             throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found after sign in"])
        }
        return User(id: user.id.uuidString, email: user.email, phone: user.phone)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    // MARK: - Usuarios

    func getCurrentUser() async throws -> User? {
        guard let session = try await client.auth.session else { return nil }
        return User(id: session.user.id.uuidString, email: session.user.email, phone: session.user.phone)
    }

    func getUserProfile(userId: String) async throws -> UserProfile {
        let response: [UserProfile] = try await client
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .execute()
            .value

        guard let profile = response.first else {
            throw NSError(domain: "DatabaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
        }
        return profile
    }

    func createUserProfile(_ profile: UserProfile) async throws {
        try await client
            .from("profiles")
            .insert(profile)
            .execute()
    }

    func updateUserProfile(_ profile: UserProfile) async throws {
        try await client
            .from("profiles")
            .update(profile)
            .eq("id", value: profile.id)
            .execute()
    }

    // MARK: - Almacenamiento

    func uploadProfileImage(userId: String, imageData: Data) async throws -> String {
        let fileName = "\(userId)/profile.jpg"

        let response = try await client
            .storage
            .from("avatars")
            .upload(
                    path: fileName,
                    data: imageData,
                    options: StorageUploadOptions(
                        contentType: "image/jpeg",
                        cacheControl: "3600"
                    )
                )

        let publicURL = try await client
                .storage
                .from("avatars")
                .createSignedURL(path: fileName, expiresIn: 3600)

        return publicURL.absoluteString
    }

    func deleteProfileImage(userId: String) async throws {
        let fileName = "\(userId)/profile.jpg"

        try await client
            .storage
            .from("avatars")
            .remove(paths: [fileName])
    }

    // MARK: - Autolavados

    func getNearbyCarWashes(latitude: Double, longitude: Double, radius: Double) async throws -> [CarWash] {
        let response: [CarWash] = try await client
            .from("car_washes")
            .select()
            .execute()
            .value

        return response
    }

    // MARK: - Suscripciones

    func getCurrentSubscription(userId: String) async throws -> Subscription? {
        let response: [Subscription] = try await client
            .from("subscriptions")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value

        return response.first
    }

    // MARK: - Historial de Lavados

    func getWashHistory(userId: String) async throws -> [WashHistory] {
        let response: [WashHistory] = try await client
            .from("wash_history")
            .select()
            .eq("user_id", value: userId)
            .order(column: "created_at", ascending: false)
            .execute()
            .value

        return response
    }

    func addWashHistory(userId: String, carWashId: String) async throws {
        try await client
            .from("wash_history")
            .insert([
                "user_id": userId,
                "car_wash_id": carWashId
            ])
            .execute()
    }
}