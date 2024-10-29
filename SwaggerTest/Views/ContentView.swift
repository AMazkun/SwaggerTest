//
//  ContentView.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            //UsersListView()
            RegistrationView()
        }
        //.padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(MokeData.shared.useMockData)
}
