import Foundation

struct SoundsModel: Identifiable, Codable, Equatable  {
    
    static func == (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name < rhs.name
    }
    
    let id: Int
    let name: String
    let description: String?
    let artist: Artist?
    let audioFileLink: String
    let imageFileLink: String
    let duration: Int
    let category: SoundCategory?
    let location: SoundLocation?
    let numberOfRatings: Int
    let averageRating: Double
    let freeSong: Bool
    
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
        case numberOfRatings = "rating_count"
        case averageRating = "average_rating"
        case freeSong = "free_song"
    }
}

struct SoundCategory: Codable {
    let id: Int
    let title: String
}

struct SoundLocation: Codable {
    let id: Int
    let title: String
}

struct Artist: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
