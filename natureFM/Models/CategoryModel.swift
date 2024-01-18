import Foundation

class CategoryModel: ObservableObject, Identifiable, Codable {
    
    var title = ""
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
    }
    
}

struct CategoryName: Identifiable, Hashable {
    let id = UUID()
    let title: String
}
