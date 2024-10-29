//
//  Users+Get.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation

extension UserModel {
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
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(usersPage)&count=\(usersPerPage)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
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
                    try self.responseStatusCode(statusCode)
                }
                return output.data
            }
            .decode(type: UsersResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.errorMessage = ""
                case .failure(let error):
                    self.failureProcess(error)
                }
            }, receiveValue: { [weak self] response in
                self?.users.append(contentsOf: response.users)
                self?.usersPages = response.total_pages
            })
            .store(in: &cancellables)
    }
    
    func responseStatusCode(_ statusCode : HTTPStatusCode) throws {
        switch statusCode {
        case .badRequest:
            throw URLError(.badURL)
        case .unauthorized:
            throw URLError(.userAuthenticationRequired)
        case .forbidden:
            throw URLError(.noPermissionsToReadFile)
        case .notFound:
            throw URLError(.fileDoesNotExist)
        case .internalServerError, .serviceUnavailable:
            throw URLError(.cannotConnectToHost)
        default :
            throw URLError(.unknown)
            
        }
    }
}
