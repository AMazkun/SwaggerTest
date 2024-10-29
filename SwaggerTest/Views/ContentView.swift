//
//  ContentView.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI
import Network

enum Views {
    case registration
    case usersList
    
    var name: String {
        switch self {
        case .registration: return "Working with POST request"
        case .usersList: return "Working with GET request"
        }
    }
}

struct ViewsSwitchings : View {
    @Binding var selectedView: Views
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            HStack{
                Image("UsersImg")
                    .renderingMode(.template)
                Text("Users")
            }.padding(.top)
                .foregroundStyle(selectedView == .usersList ? Color("secondaryColor") : .gray)
                .onTapGesture {
                    if selectedView == .registration {
                        selectedView = .usersList
                    }
                }
            Spacer()
            HStack{
                Image("NoUserImg")
                    .renderingMode(.template)
                Text("Sign up")
            }.padding(.top)
                .foregroundStyle(selectedView == .registration ? Color("secondaryColor") : .gray)
                .onTapGesture {
                    if selectedView == .usersList {
                        selectedView = .registration
                    }
                }
            Spacer()
        }
        .background(backgroundGray)
    }
    
}

struct ContentView: View {
    @EnvironmentObject private var userModel : UserModel
    private let monitor = NWPathMonitor()
    @State private var selectedView: Views = .usersList
    
    var body: some View {
        VStack {
            if userModel.isConnected {
                Rectangle()
                    .fill(Color("primaryColor"))
                    .overlay(
                        Text(selectedView.name)
                            .nunitoSansFont(.Heading1)
                            .padding()
                    )
                    .frame(height: rawHeight)
                
                GeometryReader { geometry in
                    ScrollView {
                        switch selectedView {
                        case .registration:
                            RegistrationView()
                        case .usersList:
                            UsersListView(listHeight: geometry.size.height)
                        }
                    }
                }
            
                ViewsSwitchings(selectedView: $selectedView)
            } else {
                NoNet()
            }
        }
        .onAppear {
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(MokeData.shared.useMockData)
}
