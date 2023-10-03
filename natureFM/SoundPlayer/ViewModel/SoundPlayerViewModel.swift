import Foundation
import Combine
import AVKit
import SwiftUI

class SoundPlayerViewModel: ObservableObject {
    
    @Published var audioPlayer = AVAudioPlayer()
    
    @Published var sound: SoundsModel
    @Published var timer = Timer.publish(every: 1.0, on: .main, in: .common)
    @Published var audioIsPlaying: Bool = false
    @Published var isShowingAudioPlayerTab: Bool = false
    @Published var isShowingAudioPlayer: Bool = false
    
    // Information to get the url
    @Published var songDataDownloadService: SongDataDownloadService
    
    @Published var soundCancellables = Set<AnyCancellable>()
    
    init(sound: SoundsModel) {
//      TODO: Need to hook up download service when we are ready to play a song
        self.sound = sound
        self.songDataDownloadService = SongDataDownloadService(soundModel: sound)
        addSubscribers()
        
    }
    
    func addSubscribers() {
        songDataDownloadService.$downloadedSound
            .sink { returnedData in
                print("data is returned from songdownloda service")
                if let data = returnedData {
                    do {
                        print("Got the audio player")
                        self.audioPlayer = try AVAudioPlayer(data: data)
                    } catch {
                        print("Error fetching audio player")
                    }
                }
            }
            .store(in: &soundCancellables)
        
        
        $audioIsPlaying
            .sink { isPlaying in
                if isPlaying {
                    self.startPlayer()
                } else {
                    self.stopPlayer()
                }
            }
            .store(in: &soundCancellables)
    }
    
    func stopPlayer() {
        audioPlayer.pause()
        timer.connect().cancel()
    }
    func startPlayer() {
        audioPlayer.play()
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timer.connect()
    }
    
    


    func skipForwardThirtySeconds() {
        if audioPlayer.currentTime + 30 > audioPlayer.duration {
            audioPlayer.currentTime = 0
            timer.connect().cancel()
            audioIsPlaying = false
            audioPlayer.pause()
            
        } else {
            audioPlayer.currentTime += 30
        }
    }
    
    func playerButtonLabel() -> some View {
        if audioIsPlaying {
            return Image(systemName: "pause.fill")
                .resizable()
                .frame(width: 40, height: 40)
            
        } else {
            return Image(systemName: "play.fill")
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
    
    
}
