//
//  Users+Get.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation

extension UserModel {
    func fetchUsers() {
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/users") else {
            self.errorMessage = "Invalid URL"
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
                }
            }
            .decode(type: UsersResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Error fetching users: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                self?.users = response.users
            })
            .store(in: &cancellables)
    }
}
