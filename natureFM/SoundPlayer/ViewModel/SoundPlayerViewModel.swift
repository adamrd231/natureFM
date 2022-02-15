//
//  SoundPlayerViewModel.swift
//  natureFM
//
//  Created by Adam Reed on 2/9/22.
//

import Foundation
import Combine
import AVKit
import SwiftUI

class SoundPlayerViewModel: ObservableObject {
    
    @Published var audioPlayer = AVAudioPlayer()
    
    @Published var sound: SoundsModel
    
    
    
    // Information to get the url
    var songDataDownloadService: SongDataDownloadService
    
    private var soundCancellables = Set<AnyCancellable>()
    
    init(sound: SoundsModel) {
        self.sound = sound
        self.songDataDownloadService = SongDataDownloadService(soundModel: sound)
        
        addSubscribers()
        
    }
    
    func addSubscribers() {
        
        songDataDownloadService.$downloadedSound
            .sink { returnedData in
                if let data = returnedData {
                    do {
                        self.audioPlayer = try AVAudioPlayer(data: data)
                    } catch {
                        print("Error")
                    }
                }
            }
            .store(in: &soundCancellables)
    }
}
