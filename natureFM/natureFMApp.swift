//
//  natureFMApp.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI

@main
struct natureFMApp: App {
    

    
    @StateObject var soundsModel = SoundsModel()
    
    var body: some Scene {
        WindowGroup {
            SoundsTableView().environmentObject(soundsModel)
        }
    }
}
