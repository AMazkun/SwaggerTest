//
//  NetworkMonitor.swift
//  SwaggerTest
//
//  Created by admin on 29.10.2024.
//


import Foundation
import Network

final class NetworkMonitor : ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    @Published var isConnected : Bool = true
    {
        didSet {
            print("isConnected", isConnected)
        }
    }
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
