import SwiftUI
import StoreKit

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {
        homeVM.allSounds.append(testSound)
        libraryVM.mySounds.append(testSound)
    }

    let libraryVM = LibraryViewModel()
    let homeVM = CatalogViewModel()
    let testSound = SoundsModel(
        id: 1,
        name: "Dale's Beat Boxing",
        description: "The one where he goes ha-cha-cha a lot.",
        artist: Artist(id: 1, name: "Dale Gribble"),
        audioFileLink: "",
        imageFileLink: "",
        duration: 100,
        category: SoundCategory(id: 1, title: "Doing stuff"),
        location: SoundLocation(id: 2, title: "Arlen"),
        numberOfRatings: 10,
        averageRating: 5,
        freeSong: true
    )
    
    let audioLink = Bundle.main.path(forResource: "launchimage", ofType: "jpg")
    let imageFileLink = ""
}
