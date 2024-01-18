import Foundation
import Combine
import SwiftUI

class CatalogViewModel: ObservableObject {
    // Services
    private let natureSoundDataService = NatureSoundDataService()
    private let categoryDataService = CategoryDataService()

    @Published var songDataDownloadService = SongDataDownloadService()
    // Published
    @Published var allSounds: [SoundsModel] = []

    @Published var allFreeSounds: [SoundsModel] = []
    @Published var allSubscriptionSounds: [SoundsModel] = []
    @Published var randomSounds: [SoundsModel] = []
    @Published var categories: [CategoryModel] = []
    @Published var randomSound: SoundsModel? = nil

    @Published var isViewingSongPlayer: Bool = false
    @Published var isViewingSongPlayerTab: Bool = false

    // Cancellable
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        natureSoundDataService.$allSounds
            .sink { [weak self] (returnedSounds) in
                self?.allSounds = returnedSounds
                // Set up arrays for free and subscription sounds
                for sound in returnedSounds {
                    if sound.freeSong == true {
                        self?.allFreeSounds.append(sound)
                    } else {
                        self?.allSubscriptionSounds.append(sound)
                    }
                    self?.randomSound = returnedSounds.randomElement()
                }
            }
            .store(in: &cancellable)
        
        categoryDataService.$allCategories
            .map(sortCategories)
            .sink { (returnedCategories) in
                self.categories = returnedCategories
            }
            .store(in: &cancellable)
    }

    func sortCategories(returnedCategories: [CategoryModel]) -> [CategoryModel] {
        var sortableCategories = returnedCategories
        sortableCategories.sort(by: ({ $0.title < $1.title}))
        // get all current category names
        var categories = allSounds.map { $0.categoryName }
        categories.append("All")
        let filtered = sortableCategories.filter { categories.contains($0.title) }
        return filtered
    }
    

}
