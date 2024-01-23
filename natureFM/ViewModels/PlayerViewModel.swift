import Foundation
import AVKit
import AVFoundation
import Combine

class PlayerViewModel: ObservableObject {
    // Sound player
    var audioPlayer: AVAudioPlayer?
    @Published var songDataDownloadService = SongDataDownloadService()
    @Published var sound: SoundsModel?
    @Published var soundsPlaylist: [SoundsModel] = []
    @Published var isPlaying: Bool = false
    @Published var percentagePlayed: Double = 0
    @Published var currentTime: Double = 0
    @Published var duration: Int = 0

    @Published var isRepeating: Bool = false
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
            .sink { returnedSound in
                if let unwrappedSound = returnedSound {
                    self.currentTime = 0
                    self.percentagePlayed = 0
                    self.duration = returnedSound?.duration ?? 0
                    self.songDataDownloadService.getSound(sound: unwrappedSound)
                }
            }
            .store(in: &cancellable)
        
        songDataDownloadService.$downloadedSound
            .sink { returnedPlayerData in
                if let data = returnedPlayerData {
                    do {
                        try self.audioPlayer = AVAudioPlayer(data: data)
                    } catch {
                        print("Error setting up audio player HOMEVIEWMODEL")
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func selectSound(newSound: SoundsModel) {
        self.sound = newSound
        self.isViewingSongPlayerTab = true
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
            if let unwrappedPlayer = self.audioPlayer {
                self.currentTime = unwrappedPlayer.currentTime
            }
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func toggleTimer() {
        if let player = audioPlayer {
            switch player.isPlaying {
            case true: print("Stop player")
            case false: print("Start player")
            }
        }
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
