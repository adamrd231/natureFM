import Foundation
import Combine
import SwiftUI

class CatalogViewModel: ObservableObject {
    // Sound Download service
    private let natureSoundDataService = NatureSoundDataService()
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
        addSubscribers()
    }
    
    func addSubscribers() {
        
        natureSoundDataService.$hasError
            .sink{ [weak self] (returnedHasError) in
                self?.hasError = returnedHasError?.localizedDescription
            }
            .store(in: &cancellable)
        
        natureSoundDataService.$isLoading
            .sink { [weak self] (returnedIsLoadingState) in
                self?.isLoadingSounds = returnedIsLoadingState
            }
            .store(in: &cancellable)
        
        natureSoundDataService.$allSounds
            .sink { [weak self] (returnedSounds) in
                self?.allSounds = returnedSounds
                self?.filteredSounds = returnedSounds
                // Set up arrays for free and subscription sounds
                var categoryArray:[CategoryName] = []
                categoryArray.append(CategoryName(title: "All"))
                for sound in returnedSounds {
                    // Setup category array
                    let newCategory = CategoryName(title: sound.categoryName)
                    if categoryArray.contains(where: { $0.title == sound.categoryName }) {
                        print("Do nothing")
                    } else {
                        categoryArray.append(newCategory)
                    }
                }
                self?.categories = categoryArray
            }
            .store(in: &cancellable)
        
        $selectedCategory
            .sink { [weak self] newCategory in
                if newCategory == 0 {
                    self?.filteredSounds = self!.allSounds
                   
                } else {
                    if let all = self?.allSounds {
                        self?.filteredSounds = all.filter({ $0.categoryName == self?.categories[newCategory].title })
                    }
                }
            }
            .store(in: &cancellable)
    }
}
