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
    let testSound = SoundsModel(id: 1, name: "Boomhower's Beat", description: "Boomhower goes all the way in on this one.", artist: Artist(id: 1, name: "Boomhower"), audioFileLink: "", imageFileLink: "", duration: 100, categoryName: "Beats", locationName: "Arlen", averageRating: 4.98, freeSong: true)
    
    let audioLink = Bundle.main.path(forResource: "launchimage", ofType: "jpg")
    let imageFileLink = ""
}
