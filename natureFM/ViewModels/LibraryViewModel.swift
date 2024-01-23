import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    let downloadedContentService = DownloadedContentService()
    
    @Published var mySounds: [SoundsModel] = []
    var filteredSounds: [SoundsModel] {
        if selectedCategory == "All" {
            return mySounds
        } else {
            return mySounds.filter({ $0.categoryName == selectedCategory })
        }
        
    }
    @Published var categories: [CategoryName] = []
    @Published var selectedCategory: String = "All"
    
    // Cancellable
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func saveSoundToLibrary(_ sound: SoundsModel) {
        downloadedContentService.saveSound(sound: sound)
    }
    
    func addSubscribers() {
        downloadedContentService.$savedEntities
            .combineLatest($selectedCategory)
            .map(mapDownloadedContent)
            .sink { [weak self] (returnedSounds) in
                self?.mySounds = returnedSounds
                
                // Gather all categories from sounds
                var categoryArray:[CategoryName] = []
                categoryArray.append(CategoryName(title: "All"))
                for sound in returnedSounds {
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
            sounds.append(newSound)
        }
        sounds.sort(by: { $0.name < $1.name })
        return sounds
    }
    
    func removeFromLibrary(sound: SoundsModel) {
        print("Remove from library \(sound.name)")
        downloadedContentService.deleteSound(sound: sound)
    }
}
