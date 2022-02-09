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
    
    @Published var allFreeSounds: [SoundsModel] = []
    
    @Published var categories: [CategoryModel] = []
    @Published var selectedCategory: String = "All"
    
    private var cancellables = Set<AnyCancellable>()
    
    private let natureSoundDataService = NatureSoundDataService()
    private let categoryDataService = CategoryDataService()
    let downloadedContentService = DownloadedContentService()
    
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
            .combineLatest($selectedCategory)
            .map(mapDownloadedContent)
            .sink { [weak self] (returnedSounds) in
                self?.portfolioSounds = returnedSounds
                for sound in returnedSounds {
                    if sound.freeSong == true && !(self?.allFreeSounds.contains(sound) ?? false) {
                        self?.allFreeSounds.append(sound)
                    }
                }
            }
            .store(in: &cancellables)
        
        categoryDataService.$allCategories
            .map(sortCategories)
            .sink { (returnedCategories) in
                
                self.categories = returnedCategories
            }
            .store(in: &cancellables)
    }
    

    func sortCategories(returnedCategories: [CategoryModel]) -> [CategoryModel] {
        var sortableCategories = returnedCategories
        sortableCategories.sort(by: ({ $0.title < $1.title}))
        
        
        
        return sortableCategories
    }
    
    func mapDownloadedContent(returnedSounds: [Sound], currentCategory: String) -> [SoundsModel] {
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
            
            if newSound.categoryName == currentCategory || currentCategory == "All" {
                sounds.append(newSound)
            }
            
        }
    
        return sounds
    }
    
}
