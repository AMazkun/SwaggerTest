//
//  DataStructures.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var email: String
    var phone: String
    var position: String
    var position_id: Int
    var registration_timestamp: Int
    var photo: String
}


struct UsersResponse: Codable {
    let success: Bool
    let total_pages: Int
    let total_users: Int
    let count: Int
    let page: Int
    let links: Links
    var users: [User]
}

struct Links: Codable {
    let next_url: String?
    let prev_url: String?
}

struct TokenResponse: Codable {
    let success: Bool
    let token: String?
    let message: String?
}


struct Position: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]?
    let message: String?
}
