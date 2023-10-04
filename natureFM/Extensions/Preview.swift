import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {
        testSound.imageFileLink = imageFileLink
        soundVM.sound?.name = "Adam is cool"
        soundVM.sound?.audioFileLink = audioLink ?? ""
        soundVM.sound?.categoryName = "Adam"
    }
    
    let homeVM = HomeViewModel()
    let soundVM = SoundPlayerViewModel()
    let testSound = SoundsModel()
    
    let audioLink = Bundle.main.path(forResource: "launchimage", ofType: "jpg")
    let imageFileLink = ""
}
