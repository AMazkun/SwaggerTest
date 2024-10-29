//
//  SwaggerTestApp.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

@main
struct SwaggerTestApp: App {
    @StateObject var model: UserModel = .init()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}