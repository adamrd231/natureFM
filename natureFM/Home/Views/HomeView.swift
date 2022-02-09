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
                // Main Container
                VStack(alignment: .leading) {
                    HeaderView()
                    // ScrollView for main container
                    ScrollView {
                        // Sections Container
                        VStack(alignment: .leading) {
                            // Section One
                            Text("All Sounds")
                                .foregroundColor(Color.theme.titleColor)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HorizontalScrollView()
                                .environmentObject(vm)
            
                            Divider()
                            VStack(alignment: .leading) {
                                Text("About Nature FM").bold()
                                Text("Nature FM is inspired directly from being outside, the sense of calm and serenity can fill you up if you can slow down, close your eyes and listen. Nature is always producing symphonies of beauty. Nature FM collects these sounds, and gathers them here in this app for users to connect to waves, wind, thunderstorms, or a part of the country they are longing for.").font(.caption)
                            }
                            .padding()
                            Divider()
                            
                            
                            // Section Two
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
                            .padding(.bottom)
                            
                            
                            
                            // Section Three
                            Text("Free Sounds")
                                .foregroundColor(Color.theme.titleColor)
                                .font(.title2)
                                .fontWeight(.bold)
                            HorizontalScrollView()
                                .environmentObject(vm)
                            
                            
                            
                        }
                    }
                    Banner()
                   
                }
                .padding()
                .tabItem { VStack {
                    Text("NATURE FM")
                    Image(systemName: "antenna.radiowaves.left.and.right")
                }}
                
                // Second Page
                // -----------
                VStack(alignment: .leading) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(vm.categories) { category in
                                Text("\(category.title)")
                                    .fontWeight((category.title == vm.selectedCategory) ? .medium : .light)
                                    .padding(.horizontal)
                                    .offset(y: (category.title == vm.selectedCategory) ? -2.0 : 0)
                                    .scaleEffect((category.title == vm.selectedCategory ? 1.5 : 1.0))
                                    .onTapGesture {
                                        vm.selectedCategory = category.title
                                    }
                            }
                        }
                        .padding()
                    }
                    
                    
                    
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

                // Fourth Page
                // -----------
                
                VStack(spacing: 5) {
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Downloaded on Jan 1 2021")
                        .font(.caption)
                    Text(storeManager.purchasedRemoveAds ? "Member" : "Free User")
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 15) {
                        VStack {
                            Text("Total Sounds")
                            Text("\(vm.allSounds.count)")
                            
                        }
                        VStack {
                            Text("Sounds Downloaded")
                            Text("\(vm.portfolioSounds.count)")
                        }
   
                    }
                    .padding(.bottom)
                    .font(.caption)
                    
                    Form {
                        Section(header: Text("Help")) {
                            VStack(alignment: .leading) {
                                Text("Help, Support, Questions, Suggestions.")
                                Text("contact@rdconcepts.design")
                                    .font(.caption)
                            }.padding()
                        }
                        
                        Section(header: Text("Share")) {
                            VStack(alignment: .leading) {
                                Text("Refer to a friend.")
                                Text("contact@rdconcepts.design")
                                    .font(.caption)
                            }.padding()
                        }
                        
                        
                        Section(header: Text("Rate")) {
                            VStack(alignment: .leading) {
                                Text("Rate the app on the app store.")
                                Text("contact@rdconcepts.design")
                                    .font(.caption)
                            }.padding()
                        }
                        
                    }
                    
                    
                    
                }.padding()
                .tabItem {
                    VStack {
                        Text("Profile")
                        Image(systemName: "person.crop.circle")
                    }
                }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())

    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(storeManager: StoreManager())
    }
}
    








