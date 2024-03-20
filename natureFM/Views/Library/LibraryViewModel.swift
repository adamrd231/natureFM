import Foundation
import Combine
import AVKit
import AVFoundation

class LibraryViewModel: ObservableObject {
    // MARK: Library --
    @Published var mySounds: [SoundsModel] = []
    @Published var categories: [CategoryName] = []
    @Published var selectedCategory: String = "All"
    
    var filteredSounds: [SoundsModel] {
        return mySounds
    }
    // Service to download song from database and save to Coredata / filemanager
    private let downloadedContentService = CoreDataService()
    
    // MARK: Sound Player
    @Published var sound: SoundsModel?
    var audioPlayer: AVAudioPlayer?
    // Service to either retrieve sounds from coredata, or download the song if needed
    @Published var songDataDownloadService = SongDataDownloadService()
    // Information to display to user
    @Published var isPlaying: Bool = false
    @Published var percentagePlayed: Double = 0
    @Published var currentTime: Double = 0
    @Published var duration: Int = 0
    @Published var isRepeating: Bool = true
    @Published var isShuffling: Bool = false
    @Published var timer = Timer()
    // Controls view
    @Published var isViewingSongPlayer: Bool = false
    @Published var isViewingSongPlayerTab: Bool = false
    // Cancellable
    private var cancellable = Set<AnyCancellable>()
    
    init() {
       
    }
    
    func saveSoundToLibrary(_ sound: SoundsModel) {
        downloadedContentService.saveSound(sound: sound)
    }
    
    

    
    func removeFromLibrary(sound: SoundsModel) {
        downloadedContentService.deleteSound(sound: sound)
    }
    
    func selectSound(newSound: SoundsModel) {
        self.sound = newSound
        self.isViewingSongPlayerTab = true
    }
    
    func startPlayer() {
        if let player = audioPlayer {
            isPlaying = true
            runTimer()
            player.play()
        }
    }
    
    func stopPlayer() {
        if let player = audioPlayer {
            isPlaying = false
            stopTimer()
            player.pause()
        }
    }
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            guard self.isPlaying == true else {
                return
            }
            guard self.audioPlayer?.isPlaying == true else {
                self.stopPlayer()
                if self.isRepeating {
                    self.startPlayer()
                } else {
                    self.currentTime = 0
                }
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
    
    func skipSongForward() {
        if let s = sound {
            if let currentIndex = mySounds.firstIndex(of: s) {
                let nextIndex = mySounds.index(after: currentIndex)
                if nextIndex > mySounds.count - 1 {
                    sound = mySounds.first
                } else {
                    sound = mySounds[nextIndex]
                }
            }
        }
    }
        
    func skipSongBackwards() {
        if let s = sound {
            if let currentIndex = mySounds.firstIndex(of: s) {
                let previousIndex = mySounds.index(before: currentIndex)
                if previousIndex < 0 {
                    sound = mySounds.last
                } else {
                    sound = mySounds[previousIndex]
                }
            }
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
}
