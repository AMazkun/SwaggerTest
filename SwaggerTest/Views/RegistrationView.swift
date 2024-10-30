//
//  RegistrationView.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import SwiftUI
import PhotosUI

struct MovingPlaceholderTF: View {
    let placeholder: String
    @Binding var text: String
    let errorText: String
    let color: Color
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization?
    
    var body: some View {
        VStack (alignment: .leading)  {
            let shift: CGFloat = text.isEmpty ? 0 : 10
            ZStack (alignment: .leading) {
                Text("\(placeholder)")
                    .nunitoSansFont(shift == 0 ? .Body1 : .Body3)
                    .foregroundStyle(color)
                    .offset(y: -shift)
                TextField("", text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(autocapitalization)
                    .keyboardType(keyboardType)
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

    @State private var colorName: Color = .gray
    @State private var errorName: String = ""
    

    @ViewBuilder
    var NameInput: some View {
        MovingPlaceholderTF(placeholder: "Name", text: $userModel.user.name, errorText: errorName,  color: colorName, keyboardType: .default, autocapitalization: .words)
            .onChange(of: userModel.user.name) {
                errorName = userModel.validateName()
                colorName = errorName.isEmpty ? .gray : .red
            }
    }
    
    @State private var colorEmail: Color = .gray
    @State private var errorEmail: String = ""
    
    @ViewBuilder
    var EmailInput: some View {
        MovingPlaceholderTF(placeholder: "Email", text: $userModel.user.email, errorText: errorEmail,  color: colorEmail, keyboardType: .emailAddress, autocapitalization: .never)
            .onChange(of: userModel.user.email) {
                errorEmail = userModel.validateEmail()
                colorEmail = errorEmail.isEmpty ? .gray : .red
            }
    }
    
    @State private var colorPhone: Color = .gray
    @State private var errorPhone: String = ""
    
    @ViewBuilder
    var PhoneInput: some View {
        MovingPlaceholderTF(placeholder: "Phone", text: $userModel.user.phone, errorText: errorPhone,  color: colorPhone, keyboardType: .phonePad, autocapitalization: .none)
            .onChange(of: userModel.user.phone) {
                errorPhone = userModel.validatePhone()
                colorPhone = errorPhone.isEmpty ? .gray : .red
            }
    }
    
    @State private var showingPhotoSource = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var avatar: UIImage? = nil
    @State private var pickerItem: PhotosPickerItem?

    @State private var colorPhoto: Color = .gray
    @State private var errorPhoto: String = ""
    
    @ViewBuilder
    var PhotoInput: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Upload your photo")
                    .nunitoSansFont(.Body2)
                    .foregroundStyle(colorPhoto)
                Spacer()
                Button( action: {
                    showingPhotoSource.toggle()
                }
                , label: {
                    Text(avatar == nil ? "Upload" : "Done")
                        .nunitoSansFont(.Body2)
                }
                )
            }.padding()
            .frame(height: rawHeight)
            .border(colorPhoto)

            Text(errorPhoto.isEmpty ? " " : "\(errorPhoto)")
                .foregroundStyle(colorPhoto)
                .nunitoSansFont(.Body3)
                .padding(.leading)
        }
        .confirmationDialog("Choose how you want to add a photo", isPresented: $showingPhotoSource, titleVisibility: .visible) {
            Button("Camera") {
            }

            Button("Gallary") {
                showingImagePicker.toggle()
            }

            Button("Cancel", role: .cancel) {
            }
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $pickerItem)
        .onChange(of: pickerItem) {
            Task { @MainActor in
                if let data = try? await pickerItem?.loadTransferable(type: Data.self) {
                    self.avatar = UIImage(data:data)
                    userModel.avatar = avatar
                    self.errorPhoto = userModel.validatePhoto()
                    self.colorPhoto = errorPhoto.isEmpty ? .gray : .red
                    return
                }
            }
        }
    }
    
    @State private var position_id: Int? = 0

    @ViewBuilder
    var PositionInput: some View {
        Text("Select your position")
            .nunitoSansFont(.Body1)
        
        
        ForEach(userModel.positions) { position in
            RadioButton(tag: position.id, selection: $position_id, label: position.name)
        }.padding(.leading)
    }
    
    var RegistrationForm: some View {
        VStack{
            VStack (alignment: .leading, spacing: 16) {
                NameInput
                
                EmailInput
                
                PhoneInput
                
                PhotoInput
                
                PositionInput
            }
            .padding()
            .padding(.top, 8)
            
            Button(action: {
                userModel.fetchToken {
                    userModel.registerUser()
                }
            }, label: {
                let disabled = !userModel.validateInputs(silent: true)
                Text("Sign up")
                    .nunitoSansFont(.Body2)
                    .padding()
                    .frame(width: 140)
                    .background(disabled ? backgroundGray : Color("primaryColor"), in: Capsule())
                    .disabled(disabled)
                
            })
        }
    }
    
    var body: some View {
        VStack {
            RegistrationForm
        }
        .overlay(content: {
            if userModel.errorMessage != nil {
                SingUpFailure()
            } else if userModel.successMessage != nil {
                SingUpSucces()
            }
        })
        .onChange(of: position_id) { _, newPosition in
            userModel.user.position_id = newPosition ?? 0
        }
        .onAppear {
            userModel.fetchPositions()
            if let firstPositionId = userModel.positions.first?.id {
                position_id = firstPositionId
            }
            //userModel.errorMessage = "Here error message - a long string to show"
            //userModel.successMessage = "No metter what to show"
        }

    }
}

#Preview {
    RegistrationView()
        .environmentObject(MokeData.shared.userMockData)
}
