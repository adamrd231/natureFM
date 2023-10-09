import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {
        homeVM.sound = testSound
        homeVM.allSubscriptionSounds.append(testSound)
    }
    
    let homeVM = HomeViewModel()
    let testSound = SoundsModel(
        name: "Adams song is a long title yo!",
        duration: 100,
        audioFileLink: "",
        imageFileLink: "http://via.placeholder.com/640x360",
        categoryName: "Rain",
        locationName: "Portland",
        freeSong: false
    )
    
    
    let audioLink = Bundle.main.path(forResource: "launchimage", ofType: "jpg")
    let imageFileLink = ""
}
