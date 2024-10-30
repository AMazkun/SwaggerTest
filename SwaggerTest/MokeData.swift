//
//  MokeData.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation

@MainActor
struct MokeData {
    static var shared = MokeData()
    var userMockData : UserModel = UserModel()
    var userMockDataError : UserModel = UserModel()
    var userMockDataSuccess : UserModel = UserModel()
    var networkMonitor : NetworkMonitor = NetworkMonitor()
    
    init() {
        userMockData.user.id = 1
        userMockData.user.name = "Mock User"
        userMockData.user.email = "mock@email.com"
        userMockData.user.phone = "+380999999999"
        userMockData.user.photo = "https://picsum.photos/200"
        userMockData.user.position = "Lawer"
        userMockData.user.position_id = 1
        
        userMockDataError.errorMessage = "Here error message - a long string to show"
        userMockDataSuccess.successMessage = "No metter what to show"
    }
}
