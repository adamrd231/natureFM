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
        
            TabView {
                
                // First Page
                // -----------
                
                VStack {
                    HeaderView()
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            Text("All Sounds")
                                .foregroundColor(Color.theme.titleColor)
                                .font(.title2)
                                .fontWeight(.bold)
                            ScrollView(.horizontal) {
                                allSoundsHorizontalScrollView
                            }
                            Text("Featured Sound")
                                .foregroundColor(Color.theme.titleColor)
                                .font(.title2)
                                .fontWeight(.bold)
                            VStack(alignment: .leading) {
                                if let sound = vm.allSounds.first {
                                    SoundImageView(sound: sound)
                                    Text(sound.name)
                                    Text(sound.locationName)
                                    Text(sound.categoryName)
                                }
                            }
                            Text("Free Sounds")
                                .foregroundColor(Color.theme.titleColor)
                                .font(.title2)
                                .fontWeight(.bold)
                            ScrollView(.horizontal) {
                                HStack(spacing: 5) {
                                    ForEach(vm.allFreeSounds) { sound in
                                        VStack(alignment: .leading, spacing: 5) {
                                            SoundImageView(sound: sound)
                                                .frame(width: 250)
                                            HStack {
                                                Button(action: {
                                                    vm.downloadedContentService.saveSound(sound: sound)
                                                }) {
                                                    Image(systemName: "arrow.down.circle.fill")
                                                        .resizable()
                                                        .frame(width: 25, height: 25)
                                                }
                                                
                                                VStack(alignment: .leading) {
                                                    Text(sound.name).font(.subheadline)
                                                    Text(sound.categoryName).font(.caption2)
                                                    Text(sound.locationName).font(.caption2)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Banner()
                }.padding()
                
                
                
               
                .tabItem { VStack {
                    Text("NATURE FM")
                    Image(systemName: "antenna.radiowaves.left.and.right")
                }}
                
                // Second Page
                // -----------
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Downloaded Songs")
                        Text("Listen without the internet.")
                    }
                    .padding(.vertical)
                    List {
                        ForEach(vm.portfolioSounds) { sound in
                            HStack {
                                SoundImageView(sound: sound)
                                    .frame(width: 100, height: 100)
                                VStack(alignment: .leading) {
                                    Text(sound.name)
                                    Text(sound.locationName)
                                    Text(sound.categoryName)
                                }
                                Spacer()
                                Button(action: {
                                    vm.downloadedContentService.deleteSound(sound: sound)
                                }) {
                                    Image(systemName: "delete.left.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }
                        }
                    }
                    if storeManager.purchasedRemoveAds == false {
                        Banner()
                    }
                }
                .padding()
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
        HStack(spacing: 5) {
            
            ForEach(vm.allSounds) { sound in
                VStack(alignment: .leading, spacing: 5) {
                    SoundImageView(sound: sound)
                        .frame(width: 250)
                    HStack {
                        Button(action: {
                            vm.downloadedContentService.saveSound(sound: sound)
                        }) {
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(sound.name).font(.subheadline)
                            Text(sound.categoryName).font(.caption2)
                            Text(sound.locationName).font(.caption2)
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
    








