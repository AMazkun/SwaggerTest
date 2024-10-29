//
//  RegistrationView.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI

fileprivate let rawHeight : CGFloat = 56
fileprivate let inpHeight : CGFloat = 24

struct MovingPlaceholderTF: View {
    let placeholder: String
    @Binding var text: String
    let errorText: String
    let color: Color
    
    var body: some View {
        VStack (alignment: .leading)  {
            let shift: CGFloat = text.isEmpty ? 0 : 10
            ZStack (alignment: .leading) {
                Text("\(placeholder)")
                    .nunitoSansFont(shift == 0 ? .Body1 : .Body3)
                    .foregroundStyle(color)
                    .offset(y: -shift)
                TextField("", text: $text)
                    .offset(y: shift)
                    .nunitoSansFont(.Body2)
                    .frame(height: inpHeight)
            }
            .padding()
            .frame(height: rawHeight)
            .border(color)
            
            Text(errorText.isEmpty ? " " : "\(errorText)")
                .foregroundStyle(color)
                .nunitoSansFont(.Body3)
                .padding(.leading)
        }
    }
}

struct RegistrationView: View {
    //@StateObject private var userModel = UserModel()
    @EnvironmentObject private var userModel : UserModel

    
    @ViewBuilder
    var ButtonRebon: some View {
        HStack(alignment: .center) {
            Spacer()
            HStack{
                Image("UsersImg")
                    .renderingMode(.template)
                Text("Users")
            }.padding(.top)
            Spacer()
            HStack{
                Image("NoUserImg")
                    .renderingMode(.template)
                Text("Sign up")
            }.padding(.top)
            Spacer()
        }
        .background(backgroundGray)

    }
    
    @State private var colorName: Color = .gray
    @State private var errorName: String = ""
    

    @ViewBuilder
    var NameInput: some View {
        MovingPlaceholderTF(placeholder: "Name", text: $userModel.user.name, errorText: errorName,  color: colorName)
            .onChange(of: userModel.user.name) {
                errorName = userModel.validateName()
                colorName = errorName.isEmpty ? .gray : .red
            }
    }
    
    @State private var colorEmail: Color = .gray
    @State private var errorEmail: String = ""
    
    @ViewBuilder
    var EmailInput: some View {
        MovingPlaceholderTF(placeholder: "Email", text: $userModel.user.email, errorText: errorEmail,  color: colorEmail)
            .onChange(of: userModel.user.email) {
                errorEmail = userModel.validateEmail()
                colorEmail = errorEmail.isEmpty ? .gray : .red
            }
    }
    
    @State private var colorPhone: Color = .gray
    @State private var errorPhone: String = ""
    
    @ViewBuilder
    var PhoneInput: some View {
        MovingPlaceholderTF(placeholder: "Phone", text: $userModel.user.phone, errorText: errorPhone,  color: colorPhone)
            .onChange(of: userModel.user.phone) {
                errorPhone = userModel.validatePhone()
                colorPhone = errorPhone.isEmpty ? .gray : .red
            }
    }
    
    @State private var colorPhoto: Color = .gray
    @State private var errorPhoto: String = ""
    
    @ViewBuilder
    var PhotoInput: some View {
        VStack {
            HStack {
                Text("Upload your photo")
                    .nunitoSansFont(.Body2)
                    .foregroundStyle(colorPhoto)
                Spacer()
                Button( action: {
                    showingPhotoSource.toggle()
                }
                , label: {
                    Text("Upload")
                        .nunitoSansFont(.Body2)
                }
                )
            }.padding()
        }
        .frame(height: rawHeight)
        .border(colorPhoto)
    }
    
    let backgroundGray = Color(red: 0.973, green: 0.973, blue: 0.973)
    @State private var showingPhotoSource = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var image: Image?
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color("primaryColor"))
                .overlay(
                    Text("Working with POST request")
                        .nunitoSansFont(.Heading1)
                        .padding()
                )
                .frame(height: rawHeight)
            
            VStack (alignment: .leading, spacing: 16) {
                NameInput
                
                EmailInput
                
                PhoneInput
                
                PhotoInput
                
                Text("Select your position")
                    .nunitoSansFont(.Body1)
                
                
                ForEach(userModel.positions) { position in
                    RadioButton(tag: position.id, selection: $userModel.position_id, label: position.name)
                }.padding(.leading)
                
            }
            .padding()
            .padding(.top, 8)
            
            Spacer()
            
            
            Button(action: {
                userModel.fetchToken {
                    userModel.registerUser()
                }
            }, label: {
                let disabled = !userModel.validateInputs()
                Text("Sign up")
                    .nunitoSansFont(.Body2)
                    .padding()
                    .frame(width: 140)
                    .background(disabled ? backgroundGray : Color("primaryColor"), in: Capsule())
                    .disabled(disabled)
                
            })
            .padding()
            
            Spacer()
            
            if let errorMessage = userModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            if let successMessage = userModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            ButtonRebon
            
        }
        .onAppear {
            userModel.fetchPositions()
        }
        .confirmationDialog("Choose how you want to add a photo", isPresented: $showingPhotoSource, titleVisibility: .visible) {
            Button("Camera") {
            }

            Button("Gellary") {
            }

            Button("Cancel", role: .cancel) {
            }
        }

    }
}

#Preview {
    RegistrationView()
        .environmentObject(MokeData.shared.useMockData)
}
