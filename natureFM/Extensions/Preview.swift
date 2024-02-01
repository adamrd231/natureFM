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
        
        homeVM.allSounds.append(testSound)
        homeVM.allSounds.append(testSound2)
        
        libraryVM.mySounds.append(testSound)
        libraryVM.mySounds.append(testSound2)
    }

    let libraryVM = LibraryViewModel()
    let homeVM = CatalogViewModel()
    let testSound = SoundsModel(
        name: "Adams song is a long title yo!",
        duration: 100,
        audioFileLink: "",
        imageFileLink: "http://via.placeholder.com/640x360",
        categoryName: "Rain",
        locationName: "Portland",
        freeSong: false
    )
    
    let testSound2 = SoundsModel(
        name: "This is a different song",
        duration: 53,
        audioFileLink: "",
        imageFileLink: URL(fileURLWithPath: "placeholder").absoluteString,
        categoryName: "Not Rain",
        locationName: "Not Portland",
        freeSong: false
    )
    
    
    let audioLink = Bundle.main.path(forResource: "launchimage", ofType: "jpg")
    let imageFileLink = ""
}
