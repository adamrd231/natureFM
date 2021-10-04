//
//  natureFMApp.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI
import AppTrackingTransparency

@main
struct natureFMApp: App {
    
    func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        // Tracking authorization completed. Start loading ads here.
      })
    }
    
    @StateObject var soundsModel = SoundsModel()
    
    var body: some Scene {
        WindowGroup {
            SoundsTableView().environmentObject(soundsModel).onAppear(perform: {
                requestIDFA()
            })
        }
    }
}
