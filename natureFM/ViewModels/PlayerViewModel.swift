import Foundation
import AVKit
import AVFoundation

class PlayerViewModel: ObservableObject {
    // Sound player
    var audioPlayer: AVAudioPlayer?
    @Published var sound: SoundsModel?
    @Published var soundsPlaylist: [SoundsModel] = []
    @Published var isPlaying: Bool = false
    @Published var percentagePlayed: Double = 0
    @Published var currentTime: Int = 0
    @Published var duration: Int = 0
    @Published var isRepeating: Bool = true
    @Published var isShuffling: Bool = false
    
    // Timer
    @Published var timer = Timer()
    
//        $sound
//            .sink { returnedSound in
//                if let unwrappedSound = returnedSound {
//                    self.currentTime = 0
//                    self.percentagePlayed = 0
//                    self.duration = returnedSound?.duration ?? 0
//                    self.songDataDownloadService.getSound(sound: unwrappedSound)
//                }
//            }
//            .store(in: &cancellable)
//
//        songDataDownloadService.$downloadedSound
//            .sink { returnedPlayerData in
//                if let data = returnedPlayerData {
//                    do {
//                        try self.audioPlayer = AVAudioPlayer(data: data)
//
//                    } catch {
//                        print("Error setting up audio player HOMEVIEWMODEL")
//                    }
//                }
//            }
//            .store(in: &cancellable)
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            guard self.isPlaying == true else { return }
            guard self.audioPlayer?.isPlaying == true else {
                self.stopPlayer()
                self.startPlayer()
                return
            }
            // Update timer elements
            
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func stopPlayer() {
        if let player = audioPlayer {
            isPlaying = false
            stopTimer()
            player.pause()
        }
    }
    
    func startPlayer() {
        if let player = audioPlayer {
            isPlaying = true
            runTimer()
            player.play()
            currentTime = Int(player.currentTime)
            percentagePlayed = player.currentTime / player.duration
        }
    }
    
    func skipForward15() {
        if let player = audioPlayer {
            if player.currentTime + 15 >= player.duration {
                player.currentTime = 0
            } else {
                player.currentTime += 15
            }
        }
    }
    
    func skipBackward15() {
        if let player = audioPlayer {
            if player.currentTime - 15 <= 0 {
                player.currentTime = 0
            } else {
                player.currentTime -= 15
            }
        }
    }
    
    func skipToNextSound() {
        if isShuffling {
            print("Shuffle")
        } else {
            print("Next song")
     
        }
    }
    
    func skipToPreviousSound() {
        print("Skip backwards")
    }
}
