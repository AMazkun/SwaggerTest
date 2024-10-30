//
//  UserModel.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//
import Foundation
import Combine
import SwiftUI

let usersPerPage = 6

class UserModel: ObservableObject {
    var usersPage: Int = 1;
    var usersPages: Int = 0;
    @Published var isLoading: Bool = false

    @Published var user = User(id: -1, name: "", email: "", phone: "", position: "", position_id: 0, registration_timestamp: -1, photo: "")
    
    @Published var users: [User] = []
    @Published var positions: [Position] = []

    @Published var token: String? = nil
    @Published var isRegistered: Bool = false
    
    @Published var successMessage: String? = nil
    @Published var errorMessage: String? = nil
    var avatar: UIImage? = nil
}
