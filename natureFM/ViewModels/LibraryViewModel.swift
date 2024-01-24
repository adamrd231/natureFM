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
        if selectedCategory == "All" {
            return mySounds
        } else {
            return mySounds.filter({ $0.categoryName == selectedCategory })
        }
    }
    // Service to download song from database and save to Coredata / filemanager
    private let downloadedContentService = DownloadedContentService()
    
    // MARK: Sound Player
    @Published var sound: SoundsModel?
    var audioPlayer: AVAudioPlayer?
    // Service to get song data from CoreData / filemanager
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
        addSubscribers()
    }
    
    func saveSoundToLibrary(_ sound: SoundsModel) {
        downloadedContentService.saveSound(sound: sound)
    }
    
    func addSubscribers() {
        downloadedContentService.$savedEntities
            .combineLatest($selectedCategory)
            .map(mapDownloadedContent)
            .sink { [weak self] (returnedSounds) in
                self?.mySounds = returnedSounds
                var categoryArray:[CategoryName] = []
                categoryArray.append(CategoryName(title: "All"))
                for sound in returnedSounds {
                    let newCategory = CategoryName(title: sound.categoryName)
                    if categoryArray.contains(where: { $0.title == sound.categoryName }) {
                    } else {
                        categoryArray.append(newCategory)
                    }
                }
                self?.categories = categoryArray
            }
            .store(in: &cancellable)
        
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
    
    func mapDownloadedContent(returnedSounds: [Sound], currentCategory: String) -> [SoundsModel] {
        var sounds: [SoundsModel] = []
        for sound in returnedSounds {
            let newSound = SoundsModel(
                name: sound.name ?? "",
                duration: Int(sound.duration),
                audioFileLink: sound.audioFile ?? "",
                imageFileLink: sound.imageFileLink ?? "",
                categoryName: sound.categoryName ?? "",
                locationName: sound.locationName ?? "",
                freeSong: sound.freeSong
            )
            sounds.append(newSound)
        }
        sounds.sort(by: { $0.name < $1.name })
        return sounds
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
