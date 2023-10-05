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
        imageFileLink: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        categoryName: "Rain",
        locationName: "Portland",
        freeSong: false
    )
    
    
    let audioLink = Bundle.main.path(forResource: "launchimage", ofType: "jpg")
    let imageFileLink = ""
}
