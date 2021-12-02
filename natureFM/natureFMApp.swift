//
//  natureFMApp.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI
import AppTrackingTransparency
import StoreKit
import CoreData

@main
struct natureFMApp: App {
    
    // Core Data Controller
    let persistenceController = PersistenceController.shared
    
    // Product Id's from App Store Connect
    var productIds = ["natureFMsubscription"]
    
    // Store Manager object to make In App Purchases
    @StateObject var storeManager = StoreManager()
    
    func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.
      })
    }
    
    var body: some Scene {
        WindowGroup {
            SoundsTableView(storeManager: storeManager, currentSearchText: "")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIds) 
                    
                })
                .onAppear(perform: {
                requestIDFA()
            })
        }
    }
}

