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
            print("Timer \(self.audioPlayer.currentTime) \(self.audioPlayer.duration)")
            self.percentagePlayed = self.audioPlayer.currentTime / self.audioPlayer.duration
            if self.audioPlayer.currentTime == 0 {
                self.audioIsPlaying = false
            }
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
    
    func skipForward15() {
        if audioPlayer.currentTime + 15 >= audioPlayer.duration {
            audioPlayer.currentTime = 0
            percentagePlayed = 0
            audioIsPlaying = false
            
        } else {
            audioPlayer.currentTime += 15
        }
    }
    func skipBackward15() {
        if audioPlayer.currentTime - 15 <= 0 {
            audioPlayer.currentTime = 0
            percentagePlayed = 0
            
        } else {
            audioPlayer.currentTime -= 15
        }
    }
}
