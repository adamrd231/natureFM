import Combine
import AVKit
import SwiftUI

class SoundPlayerViewModel: ObservableObject {
    @Published var audioPlayer = AVAudioPlayer()
    @Published var sound: SoundsModel?
    @Published var timer = Timer()
    @Published var audioIsPlaying: Bool = false
    
    // Information to get the url
    @Published var songDataDownloadService = SongDataDownloadService()
    @Published var soundCancellables = Set<AnyCancellable>()
    @Published var percentagePlayed: Double = 0
    
    init() {
        addSubscribers()
        
    }
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            self.percentagePlayed = self.audioPlayer.currentTime / self.audioPlayer.duration
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
  
    
    func addSubscribers() {
        $sound
            .sink { returnedSound in
                if let unwrappedSound = returnedSound {
                    self.songDataDownloadService.getSound(sound: unwrappedSound)
                }
               
            }
            .store(in: &soundCancellables)
        
        songDataDownloadService.$downloadedSound
            .sink { returnedData in
                if let data = returnedData {
                    do {
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
                    print("playing")
                    self.startPlayer()
                } else {
                    self.stopPlayer()
                }
            }
            .store(in: &soundCancellables)
    }
    
    func stopPlayer() {
        audioPlayer.pause()
        stopTimer()
        
    }
    func startPlayer() {
        audioPlayer.play()
        runTimer()
    }
    
    func skipForwardThirtySeconds() {
        if audioPlayer.currentTime + 30 > audioPlayer.duration {
            audioPlayer.currentTime = 0
            runTimer()
            audioIsPlaying = false
            audioPlayer.pause()
            
        } else {
            audioPlayer.currentTime += 30
        }
    }
}
