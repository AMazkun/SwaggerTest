//
//  SingUpFailure.swift
//  SwaggerTest
//
//  Created by admin on 29.10.2024.
//

import SwiftUI

struct SingUpFailure: View {
    @EnvironmentObject private var userModel : UserModel
    var body: some View {
        ZStack {
            Color("backgroundColor")
            
            VStack(spacing: 30) {
                Image("NoRegisteredImg")
                
                Text(userModel.errorMessage ?? "Unknown registration error")
                    .nunitoSansFont(.Heading1)
                
                Button(action: {
                    userModel.errorMessage = nil
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
    SingUpFailure()
        .environmentObject(MokeData.shared.userMockDataError)
}
