//
//  DownloadedContentService.swift
//  natureFM
//
//  Created by Adam Reed on 2/7/22.
//

import Foundation
import CoreData

class DownloadedContentService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "Stash"
    private let entityName: String = "Sound"
    
    @Published var savedEntities: [Sound] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print(
                    """
                    Error loading core data:
                    \(error)
                    """
                )
            }
            self.getSounds()
        }
    }
    
    private func getSounds() {
        let request = NSFetchRequest<Sound>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Portfolio: \(error)")
        }
    }
    
    func saveSound(sound: SoundsModel) {
        
        if let entity = savedEntities.first(where: { $0.name == sound.name }) {
            // Entity Already exists, return
            return
        }
        
        
        let soundToSave = Sound(context: container.viewContext)
        soundToSave.name = sound.name
        soundToSave.audioFile = sound.audioFileLink
        soundToSave.imageFileLink = sound.imageFileLink
        soundToSave.freeSong = sound.freeSong
        soundToSave.duration = Int64(sound.duration)
        soundToSave.categoryName = sound.categoryName
        soundToSave.locationName = sound.locationName
        
        applyChanges()
        
    }
    

    
    private func save() {
        do {
            try container.viewContext.save()
            
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    
    private func applyChanges() {
        save()
        getSounds()
    }
    
    func deleteSound(sound: SoundsModel) {
        if let soundToDelete = savedEntities.first(where: { $0.name == sound.name }) {
            container.viewContext.delete(soundToDelete)
            applyChanges()
        }
        
        
    }
    
}
