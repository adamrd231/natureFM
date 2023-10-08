import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var allSounds: [SoundsModel] = []
    @Published var portfolioSounds: [SoundsModel] = []
    @Published var allFreeSounds: [SoundsModel] = []
    @Published var allSubscriptionSounds: [SoundsModel] = []
    @AppStorage("natureFMCoins") var natureFMCoins: Int = 0

    @Published var randomSound: SoundsModel?
    
    @Published var categories: [CategoryModel] = []
    @Published var selectedCategory: String = "All"
    
    @Published var isViewingSongPlayer: Bool = false
    @Published var isViewingSongPlayerTab: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let natureSoundDataService = NatureSoundDataService()
    private let categoryDataService = CategoryDataService()
    let downloadedContentService = DownloadedContentService()
    
    init() {
        addSubcribers()
        loadPersist()
    }
    
    func persist(coinCount: Int) {
        print("persisting")
        if let encoded = try? JSONEncoder().encode(coinCount) {
            UserDefaults.standard.set(encoded, forKey: "natureFMCoins")
        }
    }
    
    func loadPersist() {
        if let data = UserDefaults.standard.data(forKey: "natureFMCoins") {
            if let decoded = try? JSONDecoder().decode(Int.self, from: data) {
                natureFMCoins = decoded
                return
            }
        }
    }
    
    func addSubcribers() {
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
                }
            }
            .store(in: &cancellables)
        
        downloadedContentService.$savedEntities
            .combineLatest($selectedCategory)
            .map(mapDownloadedContent)
            .sink { [weak self] (returnedSounds) in
                self?.portfolioSounds = returnedSounds
            }
            .store(in: &cancellables)
        
        categoryDataService.$allCategories
            .map(sortCategories)
            .sink { (returnedCategories) in
                
                self.categories = returnedCategories
            }
            .store(in: &cancellables)
    }
    

    func sortCategories(returnedCategories: [CategoryModel]) -> [CategoryModel] {
        var sortableCategories = returnedCategories
        sortableCategories.sort(by: ({ $0.title < $1.title}))
        
        // get all current category names
        var categories = portfolioSounds.map{ $0.categoryName }
        categories.append("All")
        
        let filtered = sortableCategories.filter { categories.contains($0.title) }
        return filtered
    }
    
    func mapDownloadedContent(returnedSounds: [Sound], currentCategory: String) -> [SoundsModel] {
        var sounds: [SoundsModel] = []
        
        for sound in returnedSounds {
            let newSound = SoundsModel(
                name: sound.name ?? "",
                duration: Int(sound.duration),
                audioFileLink: sound.audioFile ?? "",
                imageFileLink: sound.imageFileLink ?? "",
                categoryName: sound.categoryName ?? "",
                locationName: sound.locationName ?? "",
                freeSong: sound.freeSong
            )
            
            if newSound.categoryName == currentCategory || currentCategory == "All" {
                sounds.append(newSound)
            }
            
        }
        
        sounds.sort(by: { $0.name < $1.name })
        
        return sounds
    }
    
}
