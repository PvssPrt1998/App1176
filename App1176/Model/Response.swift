// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let response = try? JSONDecoder().decode(Response.self, from: jsonData)

import Foundation

// MARK: - Response
struct Response: Codable {
    let id, state: String
    let failureReason: String?
    let createdAt: String
    let assets: Assets?
    let version: String?
    let request: Request

    enum CodingKeys: String, CodingKey {
        case id, state
        case failureReason = "failure_reason"
        case createdAt = "created_at"
        case assets, version, request
    }
}

// MARK: - Assets
struct Assets: Codable {
    let video: String?
    let image: String?
}

// MARK: - Request
struct Request: Codable {
    let prompt, aspectRatio: String
    let loop: Bool
    let keyframes: Keyframes?

    enum CodingKeys: String, CodingKey {
        case prompt
        case aspectRatio = "aspect_ratio"
        case loop, keyframes
    }
}

// MARK: - Keyframes
struct Keyframes: Codable {
    let frame0: Frame0
    let frame1: Frame1
}

// MARK: - Frame0
struct Frame0: Codable {
    let type: String
    let url: String
}

// MARK: - Frame1
struct Frame1: Codable {
    let type, id: String
}
