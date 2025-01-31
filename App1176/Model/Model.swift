import Foundation

struct Video: Hashable {
    let id: String
    let promt: String
    var previewImageUrl: String
    let createdAt: String
}

struct ImageResponse: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
