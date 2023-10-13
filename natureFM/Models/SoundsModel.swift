import Foundation

struct SoundsModel: Identifiable, Codable, Equatable  {
    
    static func == (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name == rhs.name
    }

    static func < (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name < rhs.name
    }

    var description: String {
        return "\(name)"
    }
    
    let id = UUID()
    var name: String
    var duration: Int
    var location: Int?
    var category: Int?
    var audioFileLink: String
    var imageFileLink: String
    var categoryName: String
    var locationName: String
    var freeSong: Bool
    
    enum CodingKeys: String, CodingKey {
        // Complete set of coding keys
        case name = "name"
        case duration = "duration"
        
        // Renamed from Database for iOS
        case audioFileLink = "audio_file"
        case categoryName = "category_name"
        case locationName = "location_name"
        case imageFileLink = "sound_image"
        case freeSong = "free_song"
        
    }
}
