//
//  Users+Get.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation

extension UserModel {
    
    func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isLoading = false
        }
    }
    
    func fetchUsersNextPage() {
        if usersPage < usersPages {
            usersPage += 1
            fetchUsers()
        }
    }

    func fetchUsersFirstPage() {
        users = []
        usersPage = 1
        fetchUsers()
    }

    func fetchUsers() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(usersPage)&count=\(usersPerPage)") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                self.stopLoading()
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                guard let statusCode = HTTPStatusCode(rawValue: response.statusCode) else {
                    throw URLError(.unknown)
                }
                switch statusCode {
                case .ok, .created, .accepted, .noContent:
                    return output.data
                default :
                    try self.responseStatusCode(statusCode, output.data)
                }
                return output.data
            }
            .decode(type: UsersResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.failureProcess(error)
                }
            }, receiveValue: { [weak self] response in
                self?.users.append(contentsOf: response.users)
                self?.usersPages = response.total_pages
            })
            .store(in: &cancellables)
    }
    
    func responseStatusCode(_ statusCode : HTTPStatusCode, _ data : Data?) throws {
        switch statusCode {
        case .badRequest:
            throw URLError(.badURL)
        case .unauthorized:
            throw RegistrationError.expiredToken
        case .forbidden:
            throw URLError(.noPermissionsToReadFile)
        case .notFound:
            throw URLError(.fileDoesNotExist)
        case .internalServerError, .serviceUnavailable:
            throw URLError(.cannotConnectToHost)
        case .noContent:
            throw URLError(.cancelled)
        case .duplicateEntry:
            throw RegistrationError.userExists(data: data)
        case .jsonError:
            throw RegistrationError.validationFailed(data: data)
        default: throw URLError(.unknown)
        }
    }
}
