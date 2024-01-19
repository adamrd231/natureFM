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
    @Published var categories: [CategoryName] = [CategoryName(title: "All")]
    @Published var selectedCategory: Int = 0
    @Published var randomSound: SoundsModel? = nil



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
                        print("Append")
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
        
//        categoryDataService.$allCategories
//            .map(sortCategories)
//            .sink { (returnedCategories) in
//                self.categories = returnedCategories
//            }
//            .store(in: &cancellable)
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
