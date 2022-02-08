//
//  SoundsTableView.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var vm: HomeViewModel
    // Store manager variable for in-app purchases
    @StateObject var storeManager: StoreManager
    
    var body: some View {
        HeaderView()
            TabView {
                // First Page
                // -----------
                Form {
                    ScrollView {
                        allSoundsHorizontalScrollView
                        downloadedSongsHorizontalScrollView
                        
                    }
                    Banner()
                }
                .tabItem { VStack {
                    Text("NATURE FM")
                    Image(systemName: "antenna.radiowaves.left.and.right")
                }}
                
                // Second Page
                // -----------
                VStack {
                    
                    if storeManager.purchasedRemoveAds == false {
                        Banner()
                    }
                }
                .tabItem { VStack {
                    Text("LIBRARY")
                    Image(systemName: "music.note.house")
                }}
                

                // Third Page
                // -----------
                InAppStorePurchasesView(storeManager: storeManager)
                .tabItem {
                VStack {
                    Text("In-App Purchases")
                    Image(systemName: "creditcard")
                }
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())

    }
}


extension HomeView {
    private var allSoundsHorizontalScrollView: some View {
        Section(header: Text("All Sounds").bold()) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(vm.allSounds) { sound in
                        ZStack {
                            SoundImageView(sound: sound)
                            Color.black
                                .opacity(0.44)
                                .cornerRadius(15.0)
                            
                            VStack {
                                Text(sound.name).foregroundColor(.white)
                                Text(sound.categoryName).font(.caption2).foregroundColor(.white)
                                Text(sound.locationName).font(.caption2).foregroundColor(.white)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    private var downloadedSongsHorizontalScrollView: some View {
        Section(header: Text("Downloaded Songs")) {
            ScrollView(.horizontal) {
                HStack {
   
                    ForEach(vm.portfolioSounds) { sound in
                        ZStack {
                            
                            Color.black
                                .opacity(0.44)
                                .cornerRadius(15.0)
                            
                            VStack {
                                Text(sound.name).foregroundColor(.white)
                                Text(sound.categoryName).font(.caption2).foregroundColor(.white)
                                Text(sound.locationName).font(.caption2).foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(storeManager: StoreManager())
    }
}
    








