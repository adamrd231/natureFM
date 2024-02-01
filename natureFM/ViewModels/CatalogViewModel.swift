import Foundation
import Combine
import SwiftUI

class CatalogViewModel: ObservableObject {

    private let natureSoundDataService = NatureSoundDataService()
    private let categoryDataService = CategoryDataService()
    @Published var songDataDownloadService = SongDataDownloadService()
    @Published var allSounds: [SoundsModel] = []
    @Published var allFreeSounds: [SoundsModel] = []
    @Published var allSubscriptionSounds: [SoundsModel] = []
    @Published var randomSounds: [SoundsModel] = []
    @Published var isLoadingSounds: Bool = false
    @Published var categories: [CategoryName] = [CategoryName(title: "All")]
    @Published var selectedCategory: Int = 0
    @Published var randomSound: SoundsModel? = nil
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        natureSoundDataService.$isLoading
            .sink { [weak self] (returnedIsLoadingState) in
                self?.isLoadingSounds = returnedIsLoadingState
            }
            .store(in: &cancellable)
        
        natureSoundDataService.$allSounds
            .sink { [weak self] (returnedSounds) in
                self?.allSounds = returnedSounds
                // Set up arrays for free and subscription sounds
                var categoryArray:[CategoryName] = []
                categoryArray.append(CategoryName(title: "All"))
                for sound in returnedSounds {
                    if sound.freeSong == true {
                        self?.allFreeSounds.append(sound)
                    } else {
                        self?.allSubscriptionSounds.append(sound)
                    }
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
                print("Updating stuff")
                if newCategory == 0 {
                    print("0")
                    self?.allFreeSounds = self!.allSounds.filter({ $0.freeSong == true })
                    self?.allSubscriptionSounds = self!.allSounds.filter({ $0.freeSong == false })
                } else {
                    print("updating")
                    if let all = self?.allSounds {
                        self?.allFreeSounds = all.filter({ $0.categoryName == self?.categories[newCategory].title && $0.freeSong == true })
                        self?.allSubscriptionSounds = all.filter({ $0.categoryName == self?.categories[newCategory].title  && $0.freeSong == false })
                    }
                }
            }
            .store(in: &cancellable)
    }
}
