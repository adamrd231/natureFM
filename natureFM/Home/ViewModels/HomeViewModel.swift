import Foundation
import Combine
import SwiftUI
//import AVKit
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
    @Published var natureFMCoins: Int = 0
    @Published var randomSound: SoundsModel?
    @Published var categories: [CategoryModel] = []
    @Published var selectedCategory: String = "All"
    @Published var isViewingSongPlayer: Bool = false
    @Published var isViewingSongPlayerTab: Bool = false
 
    @Published var sound: SoundsModel?
    @Published var soundsPlaylist: [SoundsModel] = []
    @Published var timer = Timer()
    @Published var percentagePlayed: Double = 0
    @Published var isAudioPlaying = false
    // Player
    var audioPlayer: AVPlayer?

    private var session = AVAudioSession.sharedInstance()
    // Cancellable
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        loadPersist()
    }
    
    private func activateSession() {
            do {
                try session.setCategory(
                    .playback,
                    mode: .default,
                    options: []
                )
            } catch _ {}
            
            do {
                try session.setActive(true, options: .notifyOthersOnDeactivation)
            } catch _ {}
            
            do {
                try session.overrideOutputAudioPort(.speaker)
            } catch _ {}
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
                    self.songDataDownloadService.getSound(sound: unwrappedSound)
                }
            }
            .store(in: &cancellable)
        
//        songDataDownloadService.$downloadedSound
//            .sink { returnedData in
//                if let data = returnedData {
//                    do {
//                        self.audioPlayer = try AVPlayer(playerItem: )
//                    } catch {
//                        print("Error fetching audio player")
//                    }
//                }
//            }
//            .store(in: &cancellable)
        
        songDataDownloadService.$downloadedSoundItem
            .sink { returnedAVPlayerItem in
                if let playerItem = returnedAVPlayerItem {
                    print("Updating audio player with player item \(playerItem)")
                    if let player = self.audioPlayer {
                        player.replaceCurrentItem(with: playerItem)
                    } else {
                        self.audioPlayer = AVPlayer(playerItem: playerItem)
                    }
                   

                }
            }
            .store(in: &cancellable)
    }
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true ) { _ in
//            self.percentagePlayed = self.audioPlayer.currentTime / self.audioPlayer.duration
            // lets try to play the next song instead of just stopping..
            // stop player
//            self.audioPlayer.pause()
            // NEW SONG --
            // get index of previous song
//            let currentIndex =
            // get next index, or if last start over
            // get new song
            // start new song
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func stopPlayer() {
        if let player = audioPlayer {
            player.pause()
        }
    }
    
    func startPlayer() {
        if let player = audioPlayer {
            print("Trying to play")
            print("Checking... \(player.status)")
            print("Checking... \(String(describing: player.currentItem))")
            print("Checking... \(String(describing: player.volume))")
//            activateSession()
            player.play()
            print(player.reasonForWaitingToPlay)
        }
    }
    
//    func skipForward15() {
//        if audioPlayer.currentTime + 15 >= audioPlayer.duration {
//            audioPlayer.currentTime = 0
//            percentagePlayed = 0
//        } else {
//            audioPlayer.currentTime += 15
//        }
//    }
//    func skipBackward15() {
//        if audioPlayer.currentTime - 15 <= 0 {
//            audioPlayer.currentTime = 0
//            percentagePlayed = 0
//        } else {
//            audioPlayer.currentTime -= 15
//        }
//    }
    
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
        var categories = portfolioSounds.map{ $0.categoryName }
        categories.append("All")
        
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
