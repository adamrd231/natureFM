//
//  SongDownloadDataService.swift
//  natureFM
//
//  Created by Adam Reed on 2/9/22.
//

import Foundation
import AVKit
import Combine
import SwiftUI

class SongDataDownloadService {
    
    @Published var downloadedSound: Data? = nil
    private let soundModel: SoundsModel
    private var songSubscription: AnyCancellable?
    
    private let fileManager = LocalFileManager.instance
    private let folderName = "sound_audio"
    private let soundName: String
    
    init(soundModel: SoundsModel) {
        self.soundModel = soundModel
        self.soundName = soundModel.name
       
        getSound(urlString: self.soundModel.audioFileLink ?? "")
        
    }
    
    // Download or pull up all sounds currently in library
    func getSound(urlString: String) {

        if let savedSoundURL = fileManager.getSoundURL(soundName: soundName, folderName: folderName) {
            
            let savedSong = fileManager.getSound(url: savedSoundURL, soundName: soundName, folderName: folderName)
            
            print("Get song from filemanager")
            downloadedSound = savedSong
  
        } else {
            print("Download song")
            downloadSound()
        }
    }
    
    
    
    
    private func downloadSound() {
        print("Url: \(soundModel.audioFileLink)")
        guard let url = URL(string: soundModel.audioFileLink) else { return }
        
        songSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> Data? in
                return data
            })
    
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedData) in
                guard let self = self, let downloadedData = returnedData else { return }
                self.downloadedSound = downloadedData
                self.songSubscription?.cancel()
                self.fileManager.saveSound(soundData: downloadedData, soundName: self.soundName, folderName: self.folderName)
            })
          
            
        

        
        
//        do {
//            let fileData = try Data(contentsOf: url)
//            downloadedSound = fileData
//        } catch {
//            print("Error converting url into data")
//        }
    }
    

}
