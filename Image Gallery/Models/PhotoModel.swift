import Foundation

struct PexelsResponse: Codable {
    let photos: [Photo]
}

struct Photo: Codable, Identifiable {
    let id: Int
    let src: PhotoSource
    let photographer: String
    let alt: String?
}

struct PhotoSource: Codable {
    let medium: String
    let large: String
    let original: String
} 