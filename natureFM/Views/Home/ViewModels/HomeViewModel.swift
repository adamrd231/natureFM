import Foundation
import Combine
import SwiftUI
import AVKit
import AVFoundation

class HomeViewModel: ObservableObject {
    // Services
    private let natureSoundDataService = NatureSoundDataService()
    private let categoryDataService = CategoryDataService()
    let downloadedContentService = DownloadedContentService()
    @Published var songDataDownloadService = SongDataDownloadService()
    // Published
    @Published var allSounds: [SoundsModel] = []
    @Published var portfolioSounds: [SoundsModel] = []
    @Published var allFreeSounds: [SoundsModel] = []
    @Published var allSubscriptionSounds: [SoundsModel] = []
    @Published var randomSound: SoundsModel?
    @Published var categories: [CategoryModel] = []
    @Published var selectedCategory: String = "All"
    @Published var isViewingSongPlayer: Bool = false
    @Published var isViewingSongPlayerTab: Bool = false
 
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
    
    // Coins
    @Published var natureFMCoins = 0
    
    // tab selection
    @Published var tabSelection = 1

    // Cancellable
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        loadPersist()
    }
    
    func addSubscribers() {
        natureSoundDataService.$allSounds
            .sink { [weak self] (returnedSounds) in
                self?.allSounds = returnedSounds
                // Set up arrays for free and subscription sounds
                for sound in returnedSounds {
                    if sound.freeSong == true {
                        self?.allFreeSounds.append(sound)
                    } else {
                        self?.allSubscriptionSounds.append(sound)
                    }
                }
            }
            .store(in: &cancellable)
        
        downloadedContentService.$savedEntities
            .combineLatest($selectedCategory)
            .map(mapDownloadedContent)
            .sink { [weak self] (returnedSounds) in
                self?.portfolioSounds = returnedSounds
            }
            .store(in: &cancellable)
        
        categoryDataService.$allCategories
            .map(sortCategories)
            .sink { (returnedCategories) in
                self.categories = returnedCategories
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
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
            guard self.isPlaying == true else { return }
            guard self.audioPlayer?.isPlaying == true else {
                self.stopPlayer()
                self.startPlayer()
                return
            }
            // Update timer elements
            if let player = self.audioPlayer {
                self.currentTime = Int(player.currentTime)
                self.percentagePlayed = player.currentTime / player.duration
                // Either reset song or play through next ones
                // if repeat play song again
                if self.currentTime >= Int(player.duration) - 1 {
                    self.currentTime = 0
                    player.currentTime = 0
                    if self.isRepeating {
                        if self.isShuffling {
                            self.sound = self.portfolioSounds.randomElement()
                        } else {
                            if let s = self.sound {
                                if let index = self.portfolioSounds.firstIndex(of: s) {
                                    if index + 1 >= self.portfolioSounds.count {
                                        if let firstSound = self.portfolioSounds.first {
                                            self.sound = firstSound
                                        }
                                        
                                    } else {
                                        self.sound = self.portfolioSounds[index + 1]
                                    }
                                }
                            }
                        }
                    } else {
                        self.stopPlayer()
                    }
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
            sound = portfolioSounds.randomElement()
        } else {
            guard let unwrappedSound = sound else { return }
            let currentIndex = portfolioSounds.firstIndex(of: unwrappedSound)
            guard let unwrappedIndex = currentIndex else { return }
            guard unwrappedIndex + 1 >= portfolioSounds.count else {
                sound = portfolioSounds[unwrappedIndex + 1]
                return
            }
            guard let s = portfolioSounds.first else { return }
            sound = s
        }
    }
    
    func skipToPreviousSound() {
        guard let unwrappedSound = sound else { return }
        let currentIndex = portfolioSounds.firstIndex(of: unwrappedSound)
        guard let unwrappedIndex = currentIndex else { return }
        
        guard unwrappedIndex - 1 < 0 else {
            sound = portfolioSounds[unwrappedIndex - 1]
            return
        }
        guard let s = portfolioSounds.last else { return }
        sound = s
    }
    
    func persist(coinCount: Int) {
        if let encoded = try? JSONEncoder().encode(coinCount) {
            UserDefaults.standard.set(encoded, forKey: "natureFMCoins")
        }
    }
    
    func loadPersist() {
        if let data = UserDefaults.standard.data(forKey: "natureFMCoins") {
            if let decoded = try? JSONDecoder().decode(Int.self, from: data) {
                natureFMCoins = decoded
                return
            }
        }
    }

    func sortCategories(returnedCategories: [CategoryModel]) -> [CategoryModel] {
        var sortableCategories = returnedCategories
        sortableCategories.sort(by: ({ $0.title < $1.title}))
        
        // get all current category names
        var categories = portfolioSounds.map { $0.categoryName }
        let filtered = sortableCategories.filter { categories.contains($0.title) }
        return filtered
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
            
            if newSound.categoryName == currentCategory || currentCategory == "All" {
                sounds.append(newSound)
            }
        }
        sounds.sort(by: { $0.name < $1.name })
        return sounds
    }
}
