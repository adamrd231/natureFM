import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    let downloadedContentService = DownloadedContentService()
    
    @Published var mySounds: [SoundsModel] = []
    @Published var categories: [CategoryModel] = []
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
            
            if newSound.categoryName == currentCategory || currentCategory == "All" {
                sounds.append(newSound)
            }
        }
        sounds.sort(by: { $0.name < $1.name })
        return sounds
    }
}
