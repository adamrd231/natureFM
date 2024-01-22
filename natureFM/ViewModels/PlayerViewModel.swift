import Foundation
import AVKit
import AVFoundation
import Combine

class PlayerViewModel: ObservableObject {
    // Sound player
    var audioPlayer: AVAudioPlayer?
    @Published var sound: SoundsModel?
    @Published var soundsPlaylist: [SoundsModel] = []
    @Published var isPlaying: Bool = false
    @Published var percentagePlayed: Double = 0
    var currentTime: Double {
        if let player = audioPlayer {
            return player.currentTime
        } else {
            return 0
        }
    }
    @Published var duration: Int = 0

    @Published var isRepeating: Bool = true
    @Published var isShuffling: Bool = false
    
    @Published var isViewingSongPlayer: Bool = false
    @Published var isViewingSongPlayerTab: Bool = false
    // Timer
    @Published var timer = Timer()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $sound
            .sink { [weak self] returnedSound in
                print("Updated sound")
                if let duration = returnedSound?.duration {
                    self?.duration = duration
                }
                
            }
            .store(in: &cancellable)
    }
    
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
