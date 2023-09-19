import Foundation
import Combine
import AVKit
import SwiftUI

class SoundPlayerViewModel: ObservableObject {
    
    @Published var audioPlayer = AVAudioPlayer()
    
    @Published var sound: SoundsModel
    @Published var timer = Timer.publish(every: 1.0, on: .main, in: .common)
    @Published var audioIsPlaying: Bool = false
    
  
    
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
    
    // MARK: Player Functions
    func startStopAudioPlayer() {
        if audioIsPlaying {
            stopAudioPlayer()
        } else {
            startAudioPlayer()
        }
    }
    
    func stopAudioPlayer() {
        audioPlayer.pause()
        timer.connect().cancel()
        audioIsPlaying = false
        print("audio is playing \(audioIsPlaying)")
    }
    
    func startAudioPlayer() {
        audioPlayer.play()
        audioIsPlaying = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timer.connect()
        
        print("audio is playing \(audioIsPlaying)")
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
