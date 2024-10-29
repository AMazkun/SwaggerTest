//
//  JobPositions.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation

extension UserModel {
    func fetchPositions() {
        self.errorMessage = nil

        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/positions") else {
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
                        try self.responseStatusCode(statusCode, output.data)
                }
                return output.data

            }
            .decode(type: PositionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.failureProcess(error)
                }
            }, receiveValue: { [weak self] response in
                if response.success, let positions = response.positions {
                    self?.positions = positions
                } else {
                    self?.errorMessage = response.message ?? "Failed to fetch positions."
                }
            })
            .store(in: &cancellables)
    }
    
    func failureProcess(_ error: Error) {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                self.errorMessage = "Error fetching positions: No internet connection"
            default:
                self.errorMessage = "Error fetching positions: \(error.localizedDescription)"
            }
        }
        self.errorMessage = "Error fetching positions: \(error.localizedDescription)"
    }
}

