//
//  UsersListEmptyView.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

struct UsersListEmptyView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image("3UserImg")
            
            Text("There are no users yet")
                .nunitoSansFont(.Heading1)
        }
        .padding()
    }
}

#Preview {
    UsersListEmptyView()
}
