//
//  JobPositions.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation

extension UserModel {
    func fetchPositions() {
        guard let url = URL(string: "https://frontend-test-assignment-api.abz.agency/api/v1/positions") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                switch response.statusCode {
                case 200:
                    return output.data
                case 404, 422:
                    throw URLError(.badServerResponse)
                default:
                    throw URLError(.unknown)
                }
            }
            .decode(type: PositionsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = "Error fetching positions: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] response in
                if response.success, let positions = response.positions {
                    self?.positions = positions
                    if let firstPositionId = positions.first?.id {
                        self?.position_id = firstPositionId
                    }

                } else {
                    self?.errorMessage = response.message ?? "Failed to fetch positions."
                }
            })
            .store(in: &cancellables)
    }
}

