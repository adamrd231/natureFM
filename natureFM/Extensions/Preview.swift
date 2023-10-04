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
    }
    
    let homeVM = HomeViewModel()
    let soundVM = SoundPlayerViewModel()
    let testSound = SoundsModel()
    
    let audioLink = ""
    let imageFileLink = ""
    
}
