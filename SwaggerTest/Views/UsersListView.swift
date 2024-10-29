//
//  UsersListView.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

struct UsersListView: View {
    @EnvironmentObject private var userModel : UserModel
    //@StateObject private var userModel = UserModel()
    
    var body: some View {
        VStack {
            if let errorMessage = userModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            List(userModel.users) { user in
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                }
            }
        }
        .onAppear {
            userModel.fetchUsers()
        }
    }
}

#Preview {
    UsersListView()
        .environmentObject(MokeData.shared.useMockData)
}
