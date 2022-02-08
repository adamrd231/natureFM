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
    
    @StateObject private var vm = HomeViewModel()
    
    // Store Manager object to make In App Purchases
    @StateObject var storeManager = StoreManager()
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
              // Tracking authorization completed. // Permission Granted
                print("Status \(status.self)")
            })
            
        } else {
            // iOS 14 is not installed yet
            print("Att: \(ATTrackingManager.trackingAuthorizationStatus)")
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(storeManager: storeManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(vm)
                .onAppear(perform: {
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIds) 
                    requestIDFA()
                })
        }
    }
}

