//
//  SoundsTableView.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI
import GoogleMobileAds

struct HomeView: View {
    
    @State var InterstitialAdCounter = 0 {
        didSet {
            if InterstitialAdCounter >= 5 {
                if storeManager.purchasedRemoveAds != true {
                    loadInterstitialAd()
                    InterstitialAdCounter = 0
                }
            }
        }
    }
    
    @State var interstitial: GADInterstitialAd?

    #if targetEnvironment(simulator)
        // Test Ad
        var googleBannerInterstitialAdID = "ca-app-pub-3940256099942544/1033173712"
    #else
        // Real Ad
        var googleBannerInterstitialAdID = "ca-app-pub-4186253562269967/5364863972"
    #endif
    
    // App Tracking Transparency - Request permission and play ads on open only
    private func loadInterstitialAd() {

        // Tracking authorization completed. Start loading ads here.
        let request = GADRequest()
            GADInterstitialAd.load(
                withAdUnitID: googleBannerInterstitialAdID,
                request: request,
                completionHandler: { [self] ad, error in
                    
                    // Check if there is an error
                    if let error = error {
                        return
                    }
                    interstitial = ad
                    let root = UIApplication.shared.windows.first?.rootViewController
                    self.interstitial?.present(fromRootViewController: root!)

                })
      }

    // Main viewmodel for app - handles api calls, data storage, modeling JSON, etc
    @EnvironmentObject var vm: HomeViewModel
    
    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    
    // Variable to control when to show the player view
    @State var showingPlayerView: Bool = false
    
    var body: some View {
        TabView {
            // Home View
            firstPage
                .tabItem { firstPageTabItem }
                .onAppear(perform: {
                    InterstitialAdCounter += 1
                    print(InterstitialAdCounter)
                })
            
            // Library View
            secondPage
                .tabItem { secondPageTabItem }
                .onAppear(perform: {
                    InterstitialAdCounter += 1
                    print(InterstitialAdCounter)
                })
            
            // In App Purchases
            InAppStorePurchasesView(storeManager: storeManager)
                .tabItem { thirdPageTabItem }
                .onAppear(perform: {
                    InterstitialAdCounter += 1
                    print(InterstitialAdCounter)
                })
                
            // User profile and App Information
            ProfileView(storeManager: storeManager)
                .environmentObject(vm)
                .tabItem { fourthPageTabItem }
                .onAppear(perform: {
                    InterstitialAdCounter += 1
                    print(InterstitialAdCounter)
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}



extension HomeView {
    
    // MARK: Page Views
    var firstPage: some View {
        VStack(alignment: .leading) {
            HeaderView()
            // ScrollView for main container
            ScrollView {
                VStack(alignment: .leading) {
                    Text("About Nature FM").bold()
                    Text("Nature FM is inspired directly from being outside, the sense of calm and serenity can fill you up if you can slow down, close your eyes and listen. Nature is always producing symphonies of beauty. Nature FM collects these sounds, and gathers them here in this app for users to connect to waves, wind, thunderstorms, or a part of the country they are longing for.").font(.caption)
                }
                .foregroundColor(Color.theme.titleColor)
                .padding(.vertical)
                .padding(.trailing)
                Divider()
                // Sections Container
                VStack(alignment: .leading) {
                    // Section One
                    Text("All Free Sounds")
                        .foregroundColor(Color.theme.titleColor)
                        .font(.title2)
                        .fontWeight(.bold)
                    HorizontalScrollView(storeManager: storeManager, soundArray: vm.allFreeSounds)
                        .environmentObject(vm)
                    
                    // Section Two
                    Divider()
                    if let randomSound = vm.allSounds.randomElement() {
                        FeaturedImageLayoutView(sound: randomSound).padding(.bottom)
                    }

                    // Section Three
                    Divider()
                    Text("Subscription Required")
                        .foregroundColor(Color.theme.titleColor)
                        .font(.title2)
                        .fontWeight(.bold)
                    HorizontalScrollView(storeManager: storeManager, soundArray: vm.allSubscriptionSounds)
                        .environmentObject(vm)
                }
            }
            if storeManager.purchasedRemoveAds != true {
                Banner()
            }
        }
        .padding()
    }
    
    
    var secondPage: some View {
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
            
            HStack {
                Text("\(vm.portfolioSounds.count) Titles")
                    .foregroundColor(Color.theme.titleColor)
                    .fontWeight(.bold)
                Spacer()

            }.padding(.horizontal)
            
            Divider()
            
            List {
                ForEach(vm.portfolioSounds) { sound in
                    HStack {
                        HStack(spacing: 10) {
                            SoundImageView(sound: sound)
                                .frame(width: 110, height: 75)
                                .clipped()
                                .shadow(radius: 3)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(sound.name)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text(sound.locationName)
                                    .font(.footnote)
                                Text(sound.categoryName)
                                    .font(.footnote)
                                HStack(spacing: 5) {
                                    Text("Length:")
                                        .font(.footnote)
                                    Text(sound.duration.returnClockFormatAsString())
                                        .font(.footnote)
                                }
                                
                            }.foregroundColor(Color.theme.titleColor)
                        }
                        .onTapGesture {
                            self.vm.selectedSound = sound
                            print(vm.selectedSound)
                            showingPlayerView.toggle()
                        }
                        Spacer()
                        LibraryMenuView(sound: sound)
                       
                    }
                    
                }
            }
            .sheet(isPresented: $showingPlayerView, content: {
                SoundPlayerView(sound: vm.selectedSound, purchasedRemoveAds: storeManager.purchasedRemoveAds)
            })
            Spacer()
            if storeManager.purchasedRemoveAds != true {
                Banner()
            }
        }
        .padding(.vertical)
    }
    
    
    // MARK: Tab Items
    var firstPageTabItem: some View {
        VStack {
            Text("NATURE FM")
            Image(systemName: "antenna.radiowaves.left.and.right")
        }
    }
    
    var secondPageTabItem: some View {
        VStack {
            Text("LIBRARY")
            Image(systemName: "music.note.house")
        }

    }
    
    var thirdPageTabItem: some View {
        VStack {
            Text("In-App Purchases")
            Image(systemName: "creditcard")
        }
    }
    
    var fourthPageTabItem: some View {
        VStack {
            Text("Profile")
            Image(systemName: "person.crop.circle")
        }
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(storeManager: StoreManager())
    }
}
    









