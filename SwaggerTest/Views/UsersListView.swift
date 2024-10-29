//
//  UsersListView.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

struct UsersListView: View {
    @EnvironmentObject private var userModel : UserModel
    var listHeight: CGFloat
    
    @ViewBuilder
    func Photo(urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .overlay(Material.ultraThin)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 44, height: 44)
            .background(Color.gray)
            .clipShape(Circle())    }
    
    @ViewBuilder
    func UserCard(user: User) -> some View {
        HStack (alignment: .top) {
            
            Photo(urlString: user.photo)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(user.name)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .nunitoSansFont(.Body2)
                Text(user.position)
                    .nunitoSansFont(.Body3)
                Text(user.email)
                    .lineLimit(1)
                    .nunitoSansFont(.Body3)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .leading)  {
                let lastUserId = userModel.users.last?.id
                List(userModel.users) { user in
                    UserCard(user: user)
                        .onAppear {
                            // Check if current item is last in the list
                            if user.id == lastUserId {
                                userModel.fetchUsersNextPage()
                            }
                        }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .frame(height: listHeight)
            }
            .onAppear {
                userModel.fetchUsersFirstPage()
            }
        }
    }
}

#Preview {
    UsersListView(listHeight: 300)
        .environmentObject(MokeData.shared.useMockData)
}
