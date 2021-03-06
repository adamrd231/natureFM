//
//  natureFMApp.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI
import AppTrackingTransparency
import StoreKit

@main
struct natureFMApp: App {
    
    // Product Id's from App Store Connect
    var productIds = ["natureFMsubscription"]
    
    @StateObject private var vm = HomeViewModel()
    
    // Store Manager object to make In App Purchases
    @StateObject var storeManager = StoreManager()
    
    @State private var showLaunchView:Bool = true
    
    // App Tracking Transparency - Request permission and play ads on open only
    private func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.
 
      })
    }
    
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView(storeManager: storeManager)
                    .environmentObject(vm)
                    .onAppear(perform: {
                        SKPaymentQueue.default().add(storeManager)
                        storeManager.getProducts(productIDs: productIds)
                    })
                
                ZStack {
                    if showLaunchView {
                        LaunchScreenView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                            
                    }
                }
                .zIndex(2.0)
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    requestIDFA()
                }
            })
            
        }
    }
}

