import Foundation
import Supabase

// MARK: - Modelos

struct User: Codable {
    let id: String
    let email: String?
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phone
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

struct CarWash: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case latitude
        case longitude
        case rating
    }
}

struct WashHistory: Codable, Identifiable {
    let id: String
    let userId: String
    let carWashId: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case carWashId = "car_wash_id"
        case createdAt = "created_at"
    }
}

struct Plan: Codable, Identifiable {
    let id: String
    let name: String
    let price: Double
    let washesIncluded: Int
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case washesIncluded = "washes_included"
        case description
    }
}