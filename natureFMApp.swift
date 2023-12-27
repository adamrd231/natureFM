//  App: Nature FM
//  Description: natureFM is an app for listening to the great outdoors wherever you go.
//
//  Stack:
//  Backend developed by Adam Reed using Django deployed on Heroku
//  Developed using swift + swiftUI
//
//  Created by Adam Reed on 8/12/21.

import SwiftUI
import AppTrackingTransparency
import StoreKit

@main
struct natureFMApp: App {
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in })
                    }
  
                if showLaunchView {
                    LaunchScreenView(showLaunchView: $showLaunchView)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
}

