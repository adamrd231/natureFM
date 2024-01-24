import Foundation
import Combine
import AVKit
import AVFoundation

class LibraryViewModel: ObservableObject {

    @Published var songDataDownloadService = SongDataDownloadService()
    @Published var sound: SoundsModel?
    @Published var soundsPlaylist: [SoundsModel] = []
    @Published var isPlaying: Bool = false
    @Published var percentagePlayed: Double = 0
    @Published var currentTime: Double = 0
    @Published var duration: Int = 0

    @Published var isRepeating: Bool = true
    @Published var isShuffling: Bool = false
    
    @Published var isViewingSongPlayer: Bool = false
    @Published var isViewingSongPlayerTab: Bool = false
    // Timer
    @Published var timer = Timer()
    
    var audioPlayer: AVAudioPlayer?
    private let downloadedContentService = DownloadedContentService()
    
    @Published var mySounds: [SoundsModel] = []
    var filteredSounds: [SoundsModel] {
        if selectedCategory == "All" {
            return mySounds
        } else {
            return mySounds.filter({ $0.categoryName == selectedCategory })
        }
        
    }
    @Published var categories: [CategoryName] = []
    @Published var selectedCategory: String = "All"
    
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
                
                // Gather all categories from sounds
                var categoryArray:[CategoryName] = []
                categoryArray.append(CategoryName(title: "All"))
                for sound in returnedSounds {
                    // Setup category array
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
    
    func skipSongForward() {
        if let s = sound {
            if let currentIndex = soundsPlaylist.firstIndex(of: s) {
                let nextIndex = soundsPlaylist.index(after: currentIndex)
                if nextIndex > soundsPlaylist.count - 1 {
                    sound = soundsPlaylist.first
                } else {
                    sound = soundsPlaylist[nextIndex]
                }
            }
        }
    }
        
    func skipSongBackwards() {
        if let s = sound {
            if let currentIndex = soundsPlaylist.firstIndex(of: s) {
                let previousIndex = soundsPlaylist.index(before: currentIndex)
                if previousIndex < 0 {
                    sound = soundsPlaylist.last
                } else {
                    sound = soundsPlaylist[previousIndex]
                }
            }
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
}
