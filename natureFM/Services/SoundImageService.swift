import Foundation
import SwiftUI
import Combine

class SoundImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let soundModel: SoundsModel
    
    private let fileManager = LocalFileManager.instance
    private let folderName = "sound_images"
    private let imageName: String
    
    init(soundModel: SoundsModel) {
        self.soundModel = soundModel
        self.imageName = soundModel.name
        getSoundImage()
    }
    
    private func getSoundImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage

        } else {
            downloadSoundImage()

        }
    }
    
    private func downloadSoundImage() {
        
        guard let url = URL(string: soundModel.imageFileLink) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
    
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
        
    }
}
