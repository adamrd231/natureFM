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
}
