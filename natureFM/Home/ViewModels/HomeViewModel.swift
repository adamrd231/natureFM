//
//  HomeViewModel.swift
//  natureFM
//
//  Created by Adam Reed on 2/7/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allSounds: [SoundsModel] = []
    @Published var portfolioSounds: [SoundsModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let natureSoundDataService = NatureSoundDataService()
    private let downloadedContentService = DownloadedContentService()
    
    init() {
        addSubcribers()
    }
    
    func printAllSounds() {
        for sound in portfolioSounds {
            print(sound.name)
        }
    }
    
    func addSubcribers() {
        natureSoundDataService.$allSounds
            .sink { [weak self] (returnedSounds) in
                
                self?.allSounds = returnedSounds
                
                for sound in self!.allSounds {
                    print("name is \(sound.name)")
                }
                
            }
            .store(in: &cancellables)
        
        downloadedContentService.$savedEntities
            .map(mapDownloadedContent)
            .sink { [weak self] (returnedSounds) in
                self?.portfolioSounds = returnedSounds
            }
            .store(in: &cancellables)
        
    }
    
    func mapDownloadedContent(returnedSounds: [Sound]) -> [SoundsModel] {
        var sounds: [SoundsModel] = []
        
        for sound in returnedSounds {
            let newSound = SoundsModel()
            newSound.name = sound.name ?? ""
            newSound.categoryName = sound.categoryName ?? ""
            newSound.locationName = sound.locationName ?? ""
            newSound.freeSong = sound.freeSong
            newSound.duration = Int(sound.duration)
            newSound.audioFileLink = sound.audioFile
            newSound.imageFileLink = sound.imageFileLink ?? ""
            
            sounds.append(newSound)
        }
        
        return sounds
    }
    
}
