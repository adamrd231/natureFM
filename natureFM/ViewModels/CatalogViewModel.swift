import Foundation
import Combine
import SwiftUI

class CatalogViewModel: ObservableObject {
    // Sound Download service
    private let natureSoundDataService = NatureSoundDataService(networkService: APINetworkService.shared)
    private let coreData = CoreDataService()
    
    @Published var allSounds: [SoundsModel] = []
    var filteredSounds: [SoundsModel] {
        if selectedCategory.title == "All" {
            return allSounds
        } else {
            return allSounds.filter({ $0.category?.title == selectedCategory.title })
        }
    }
    @Published var randomSounds: [SoundsModel] = []
    
    @Published var isLoadingSounds: Bool = false
    @Published var hasError: String? = nil
    // Create list of categories from sounds download
    @Published var categories: Set<CategoryName> = [CategoryName(title: "All")]
    @Published var selectedCategory: CategoryName = CategoryName(title: "All")
    // Combine
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        getCatalogSounds()
    }
    
    func getCatalogSounds() {
        isLoadingSounds = true
        hasError = nil
        natureSoundDataService.getCatalogSounds { result in
            switch result {
            case .success(let sounds):
                DispatchQueue.main.async {
                    self.isLoadingSounds = false
                    self.allSounds = sounds
//                    for sound in sounds {
//                        self.categories.insert(CategoryName(title: sound.categoryName))
//                    }
                }
            case .failure(let error):
                print("error \(error)")
                DispatchQueue.main.async {
                    self.isLoadingSounds = false
                    self.hasError = error.localizedDescription
                }
            }
        }
    }
}
