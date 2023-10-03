import Foundation
import AVKit
import Combine
import SwiftUI

class SongDataDownloadService {
    
    @Published var downloadedSound: Data? = nil
//    @Published var soundModel: SoundsModel?

    private let fileManager = LocalFileManager.instance
    private let folderName = "sound_audio"
    
    private var songSubscription: AnyCancellable?
    
  
    
    // Download or pull up all sounds currently in library
    func getSound(sound: SoundsModel) {
        print("Getting sound")
    
        print("Checking if we have sound")
        let soundName = sound.name
        if let savedSoundURL = fileManager.getSoundURL(soundName: soundName, folderName: folderName) {
            
            let savedSong = fileManager.getSound(url: savedSoundURL, soundName: soundName, folderName: folderName)
            
            print("Get song from filemanager")
            downloadedSound = savedSong
  
        } else {
            print("Download song")
            downloadSound(sound: sound)
        }
    }
    
    
    
    
    private func downloadSound(sound: SoundsModel) {
        let soundName = sound.name
        print("Url: \(sound.audioFileLink)")
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
          
            
        

        
        
//        do {
//            let fileData = try Data(contentsOf: url)
//            downloadedSound = fileData
//        } catch {
//            print("Error converting url into data")
//        }
    }
    

}
