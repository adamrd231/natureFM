import Foundation

struct SoundsModel: Identifiable, Codable, Equatable  {
    
    static func == (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name < rhs.name
    }
    
    let id: Int
    var name: String
    let description: String?
    let artist: Artist?
    var audioFileLink: String
    var imageFileLink: String
    var duration: Int
    var category: Int?
    var location: Int?
    var categoryName: String
    var locationName: String
    let averageRating: Double?
    var freeSong: Bool
    
    enum CodingKeys: String, CodingKey {
        // Complete set of coding keys
        case id
        case name
        case description
        case artist
        case audioFileLink = "audio_file"
        case imageFileLink = "sound_image"
        case duration
        case category
        case location
        case categoryName = "category_name"
        case locationName = "location_name"
        case averageRating = "average_rating"
        case freeSong = "free_song"
    }
}

struct Artist: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
