import Foundation
import Combine
import SwiftUI

class CatalogViewModel: ObservableObject {
    // Sound Download service
    private let natureSoundDataService = NatureSoundDataService(networkService: APINetworkService.shared)
    
    @Published var allSounds: [SoundsModel] = []
    var filteredSounds: [SoundsModel] = []
    @Published var randomSounds: [SoundsModel] = []
    
    @Published var isLoadingSounds: Bool = false
    @Published var hasError: String? = nil
    // Create list of categories from sounds download
    @Published var categories: [CategoryName] = [CategoryName(title: "All")]
    @Published var selectedCategory: Int = 0
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
