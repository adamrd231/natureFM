import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {
        soundVM.sound = testSound
    }
    
    let homeVM = HomeViewModel()
    let soundVM = SoundPlayerViewModel()
    let testSound = SoundsModel(
        name: "Adams song",
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
