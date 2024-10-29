//
//  NoNet.swift
//  SwaggerTest
//
//  Created by admin on 29.10.2024.
//

import SwiftUI

struct NoNet: View {
    @EnvironmentObject private var userModel : UserModel
    var body: some View {
        VStack(spacing: 30) {
            Image("NoInet")
            
            Text("There is no internet connection")
                .nunitoSansFont(.Body2)
            
            Button(action: {
                userModel.isConnected = true;
            }, label: {
                Text("Try again")
                    .nunitoSansFont(.Body2)
                    .padding()
                    .frame(width: 140)
                    .background(Color("primaryColor"), in: Capsule())
                
            })
        }
        .padding()
    }
}

//struct NoNetTests : View {
//    @State var isPresent: Bool = true
//    var body: some View {
//        NoNet(isPresent: $isPresent)
//    }
//}

#Preview {
    //NoNetTests()
    NoNet()
}
