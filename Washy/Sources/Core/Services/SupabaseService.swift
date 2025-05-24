import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    private let client: SupabaseClient
    
    private init() {
        let supabaseURL = "https://hrwqcsiwvudixifdwtoi.supabase.co"
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhyd3Fjc2l3dnVkaXhpZmR3dG9pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxMTI5MTIsImV4cCI6MjA2MzY4ODkxMn0.RDwT740wGQUxGWOz9XgqPtUC_1lBQjDUT9RDPReJKtQ"
        
        client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    // MARK: - Autenticación
    
    func signUp(email: String, password: String) async throws -> User {
        try await client.auth.signUp(
            email: email,
            password: password
        )
    }
    
    func signIn(email: String, password: String) async throws -> User {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - Usuarios
    
    func getCurrentUser() async throws -> User? {
        try await client.auth.session?.user
    }
    
    func getUserProfile(userId: String) async throws -> UserProfile {
        try await client
            .database
            .from("profiles")
            .select()
            .eq("id", value: userId)
            .single()
            .execute()
            .value
    }
    
    func createUserProfile(_ profile: UserProfile) async throws {
        try await client
            .database
            .from("profiles")
            .insert(profile)
            .execute()
    }
    
    func updateUserProfile(_ profile: UserProfile) async throws {
        try await client
            .database
            .from("profiles")
            .update(profile)
            .eq("id", value: profile.id)
            .execute()
    }
    
    // MARK: - Almacenamiento
    
    func uploadProfileImage(userId: String, imageData: Data) async throws -> String {
        let fileName = "\(userId)/profile.jpg"
        
        try await client
            .storage
            .from("avatars")
            .upload(
                path: fileName,
                file: imageData,
                fileOptions: FileOptions(
                    contentType: "image/jpeg",
                    upsert: true
                )
            )
        
        let publicURL = try await client
            .storage
            .from("avatars")
            .getPublicUrl(path: fileName)
            .data
        
        return publicURL
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
        try await client
            .database
            .from("car_washes")
            .select()
            .execute()
            .value
    }
    
    // MARK: - Suscripciones
    
    func getCurrentSubscription(userId: String) async throws -> Subscription? {
        try await client
            .database
            .from("subscriptions")
            .select()
            .eq("user_id", value: userId)
            .single()
            .execute()
            .value
    }
    
    // MARK: - Historial de Lavados
    
    func getWashHistory(userId: String) async throws -> [WashHistory] {
        try await client
            .database
            .from("wash_history")
            .select()
            .eq("user_id", value: userId)
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
    func addWashHistory(userId: String, carWashId: String) async throws {
        try await client
            .database
            .from("wash_history")
            .insert([
                "user_id": userId,
                "car_wash_id": carWashId
            ])
            .execute()
    }
}

// MARK: - Modelos

struct User: Codable {
    let id: String
    let email: String?
    let phone: String?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phone
        case createdAt = "created_at"
    }
}

struct UserProfile: Codable {
    let id: String
    var fullName: String
    let email: String?
    var phone: String?
    var avatarUrl: String?
    let createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phone
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Subscription: Codable {
    let id: String
    let userId: String
    let planId: String
    let status: String
    let currentPeriodStart: Date
    let currentPeriodEnd: Date
    let washesRemaining: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case planId = "plan_id"
        case status
        case currentPeriodStart = "current_period_start"
        case currentPeriodEnd = "current_period_end"
        case washesRemaining = "washes_remaining"
    }
} 