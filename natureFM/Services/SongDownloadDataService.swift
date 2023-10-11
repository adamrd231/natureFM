import Foundation
import AVKit
import Combine
import SwiftUI

class SongDataDownloadService {
    @Published var downloadedSound: Data? = nil

    private let fileManager = LocalFileManager.instance
    private let folderName = "soundAudio"
    private var songSubscription: AnyCancellable?
    
    // Download or pull up all sounds currently in library
    func getSound(sound: SoundsModel) {
        let soundName = sound.name
        if let savedSoundPath = fileManager.getSoundURL(soundName: soundName, folderName: folderName) {
            let soundData = fileManager.getSound(url: savedSoundPath, soundName: soundName, folderName: folderName)
            downloadedSound = soundData
        }
    }
    
    private func downloadSound(sound: SoundsModel) {
        print("Downloading sound")
        let soundName = sound.name
        guard let url = URL(string: sound.audioFileLink) else { return }
        
        songSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> Data? in
                return data
            })
    
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                guard let self = self, let downloadedData = returnedData else { return }
        
                self.downloadedSound = downloadedData
                self.songSubscription?.cancel()
                
                // Update this to not save if playing from main screen
                self.fileManager.saveSound(soundData: downloadedData, soundName: soundName, folderName: self.folderName)
            })
          
        do {
            let fileData = try Data(contentsOf: url)
            downloadedSound = fileData
        } catch {
            print("Error converting url into data")
        }
    }
    

}
