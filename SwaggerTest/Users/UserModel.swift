//
//  UserModel.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//
import Foundation
import Combine

class UserModel: ObservableObject {
    @Published var user = User(id: -1, name: "", email: "", phone: "", position: "", position_id: -1, registration_timestamp: -1, photo: "")
    @Published var position_id: Int? = 0
    
    @Published var users: [User] = []
    @Published var positions: [Position] = []

    @Published var token: String? = nil
    @Published var isRegistered: Bool = false
    
    @Published var successMessage: String? = nil
    @Published var errorMessage: String? = nil
}
