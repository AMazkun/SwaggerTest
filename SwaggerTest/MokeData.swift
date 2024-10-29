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
    var useMockData : UserModel = UserModel()
    var networkMonitor : NetworkMonitor = NetworkMonitor()
    
    init() {
        useMockData.user.id = 1
        useMockData.user.name = "Mock User"
        useMockData.user.email = "mock@email.com"
    }
}
