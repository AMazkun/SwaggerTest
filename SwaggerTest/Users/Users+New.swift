//
//  Users+New.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation
import SwiftUI

extension UserModel {
   
    func validatePhone() -> String {
        guard user.phone.starts(with: "+380") && user.phone.count == 13 else {
            return "Phone number should start with +380."
        }
        
        func isValidphone(_ phone: String) -> Bool {
            let phoneRegEx = "[+]{0,1}380([0-9]{9})"
            let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
            return phonePred.evaluate(with: phone)
        }

        guard isValidphone(user.phone) else {
            return "Invalid phone number format."
        }
        return ""
    }

    func validateEmail() -> String {
        func isValidEmail(_ email: String) -> Bool {
            let emailRegEx = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }

        guard isValidEmail(user.email) else {
            return "Invalid email format."
        }
        return ""
    }

    func validateName() -> String {
        guard user.name.count >= 2 && user.name.count <= 60 else {
            return  "Name should be 2-60 characters long."
        }
        return ""
    }

    func validatePhoto() -> String {
        if let avatar = avatar {
            if let avatarJpeg = avatar.jpegData(compressionQuality: 0.6) {
                let avatarSize = avatarJpeg.count
                //print(#function, "avatarSize: \(avatarSize), maxSize: \(5 * 1024 * 1024), width: \(avatar.size.width), height: \(avatar.size.height)")
                guard avatarSize <= 5 * 1024 * 1024 && avatar.size.width >= 70 && avatar.size.height  >= 70 else {
                    return  "Photo size must be from 70x70 but not exceed 5MB."
                }
            }

        } else {
            return  "No photo selected."
        }
        return ""
    }

    
    func validateInputs(silent : Bool = false) -> Bool {
        let res = validatePhoto() + validateName() + validateEmail() + validatePhone()
        if !res.isEmpty {
            if (!silent) {errorMessage = res}
            return false
        }
        return true
    }
    
    func registerUser() {
        self.errorMessage = nil
        guard validateInputs() else { return }

        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Token")
        
        var formData = MultipartFormData()
        formData.addField(name: "name", value: user.name)
        formData.addField(name: "email", value: user.email)
        formData.addField(name: "phone", value: user.phone)
        formData.addField(name: "position_id", value: String(user.position_id))
        print(#function, user)

        if let imageData = avatar?.jpegData(compressionQuality: 0.6) {
            formData.addFileField(name: "photo", fileName: "\(user.name.replacingOccurrences(of: " ", with: "")).jpg", mimeType: "image/jpeg", fileData: imageData)
        }
        
        request.setValue(formData.getContentType(), forHTTPHeaderField: "Content-Type")
        request.httpBody = formData.getHttpBody()

        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                guard let statusCode = HTTPStatusCode(rawValue: response.statusCode) else {
                    throw URLError(.unknown)
                }
                switch statusCode {
                case .created:
                    return output.data
                default :
                    try self.responseStatusCode(statusCode, output.data)
                }
                return output.data
            }

            .decode(type: RegistrationResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.errorMessage = nil
                case .failure(let error):
                    self.handleUserRegisterError(error)
                }
            }, receiveValue: { [weak self] response in
                self?.successMessage = response.message
                self?.user.id = response.user_id ?? 0
            })
            .store(in: &cancellables)
    }
    
    private func handleUserRegisterError(_ error: Error) {


        if let registrationError = error as? RegistrationError {
            switch registrationError {
            case .expiredToken:
                errorMessage = "The token expired."
            case .userExists(let data):
                if let userExistsError = try? JSONDecoder().decode(OtherResponse.self, from: data ?? Data()) {
                    errorMessage = userExistsError.message
                } else {
                    errorMessage = "User with this phone or email already exists."
                }
            case .validationFailed(let data):
                if let validationError = try? JSONDecoder().decode(ValidationErrorResponse.self, from: data ?? Data()) {
                    errorMessage = validationError.message + ": " + validationError.fails.map { "\($0.key): \($0.value.joined(separator: ", "))" }.joined(separator: "; ")
                } else {
                    errorMessage = "Validation failed."
                }
            }
        } else {
            failureProcess(error)
        }
        print(#function, error.localizedDescription, errorMessage ?? "no message")
    }
    
    func fetchToken( completion: @escaping () -> Void) {
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/token") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: TokenResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = "Error fetching token: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                if response.success, let token = response.token {
                    self?.token = token
                    completion()
                } else {
                    self?.errorMessage = response.message ?? "Failed to fetch token."
                }
            })
            .store(in: &cancellables)
    }
}
