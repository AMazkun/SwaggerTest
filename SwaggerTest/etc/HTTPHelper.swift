//
//  HTTPHelper.swift
//  SwaggerTest
//
//  Created by admin on 28.10.2024.
//

import Foundation
import Combine

var cancellables = Set<AnyCancellable>()

enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case duplicateEntry = 409
    case jsonError = 422
    case internalServerError = 500
    case serviceUnavailable = 503

    var description: String {
        switch self {
        case .ok: return "OK"
        case .created: return "Created"
        case .accepted: return "Accepted"
        case .noContent: return "No Content"
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Expired token response"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .jsonError: return "A JSON object containing errors"
        case .internalServerError: return "Internal Server Error"
        case .serviceUnavailable: return "Service Unavailable"
        case .duplicateEntry: return "Phone or email already exists in database response"
        }
    }
}

enum RegistrationError: Error {
    case expiredToken
    case userExists(data: Data?)
    case validationFailed(data: Data?)
}

struct RegistrationResponse: Codable {
    let success: Bool
    let user_id: Int?
    let message: String
}

struct OtherResponse: Codable {
    let success: Bool
    let message: String
}

struct ValidationErrorResponse: Codable {
    let success: Bool
    let message: String
    let fails: [String: [String]]
}

struct MultipartFormData {
    private var boundary: String
    private var httpBody = NSMutableData()

    init() {
        self.boundary = UUID().uuidString
    }

    mutating func addField(name: String, value: String) {
        httpBody.appendString("--\(boundary)\r\n")
        httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        httpBody.appendString("\(value)\r\n")
    }

    mutating func addFileField(name: String, fileName: String, mimeType: String, fileData: Data) {
        httpBody.appendString("--\(boundary)\r\n")
        httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
        httpBody.appendString("Content-Type: \(mimeType)\r\n\r\n")
        httpBody.append(fileData)
        httpBody.appendString("\r\n")
    }

    func getHttpBody() -> Data {
        httpBody.appendString("--\(boundary)--\r\n")
        return httpBody as Data
    }

    func getContentType() -> String {
        return "multipart/form-data; boundary=\(boundary)"
    }
}

private extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

