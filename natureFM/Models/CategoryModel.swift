
import Foundation

class CategoryModel: ObservableObject, Identifiable, Codable, CustomStringConvertible {
    
    var description: String = ""
    
    var title = ""
    
    enum CodingKeys: String, CodingKey {
        // Complete set of coding keys
        case title = "title"
    }
    
}
