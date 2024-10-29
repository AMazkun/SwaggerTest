//
//  SingUpFailure.swift
//  SwaggerTest
//
//  Created by admin on 29.10.2024.
//

import SwiftUI

struct SingUpFailure: View {
    var body: some View {
        VStack(spacing: 30) {
            Image("NoRegisteredImg")
            
            Text("User successfully registered")
                .nunitoSansFont(.Body2)
            
            Button(action: {
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

#Preview {
    SingUpFailure()
}
