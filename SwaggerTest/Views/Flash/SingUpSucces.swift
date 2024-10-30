//
//  SingUpSucces.swift
//  SwaggerTest
//
//  Created by admin on 29.10.2024.
//

import SwiftUI

struct SingUpSucces: View {
    @EnvironmentObject private var userModel : UserModel
    var body: some View {
        ZStack {
            Color("backgroundColor")

            VStack(spacing: 30) {
                Image("RegisteredImg")
                
                Text("User successfully registered")
                    .nunitoSansFont(.Body2)
                
                Button(action: {
                    userModel.successMessage = nil
                }, label: {
                    Text("Got it")
                        .nunitoSansFont(.Body2)
                        .padding()
                        .frame(width: 140)
                        .background(Color("primaryColor"), in: Capsule())
                    
                })
            }
            .padding()
        }
    }
}

#Preview {
    SingUpSucces()
        .environmentObject(MokeData.shared.userMockDataError)
}
