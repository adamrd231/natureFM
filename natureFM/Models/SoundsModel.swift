import Foundation

class SoundsModel: ObservableObject, Identifiable, Codable, CustomStringConvertible, Comparable {
    
    static func == (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: SoundsModel, rhs: SoundsModel) -> Bool {
        return lhs.name < rhs.name
    }
    
    var description: String {
        return "\(name)"
    }
    
    var name = ""
    var duration: Int = 0
    var location: Int?
    var category: Int?
    var audioFileLink = ""
    var imageFileLink = ""
    var categoryName = ""
    var locationName = ""
    var freeSong = false
    
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
