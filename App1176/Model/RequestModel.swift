import Foundation

// MARK: - ImageGenerationResult
struct RequestWithFrames: Codable {
    let promt: String
    let aspectRatio: String?
    let keyframes: KeyframesRequest?
}

// MARK: - Keyframes
struct KeyframesRequest: Codable {
    let frame0: Frame0Request?
    let frame1: Frame1Request?
}

// MARK: - Frame0
struct Frame0Request: Codable {
    let type: String
    let url: String
}

// MARK: - Frame0
struct Frame1Request: Codable {
    let type: String
    let url: String
}
