import SwiftUI
import GoogleMobileAds

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel

    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    
    // Variable to control when to show the player view
    @State var showingPlayerView: Bool = false
    
    var body: some View {
        TabView {
            // Home View
            firstPage
                .tabItem {
                    TabItemView(text: "Browse", image: "antenna.radiowaves.left.and.right")
                }
            
            // Library View
            secondPage
                .tabItem {
                    TabItemView(text: "Library", image: "music.note.house")
                }
            
            // In App Purchases
            InAppStorePurchasesView(storeManager: storeManager)
                .tabItem {
                    TabItemView(text: "In-App Purchases", image: "creditcard")
                }
                
            // User profile and App Information
            ProfileView(storeManager: storeManager)
                .environmentObject(vm)
                .tabItem {
                    TabItemView(text: "Profile", image: "person.crop.circle")
                }
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
        }
    }
    
    
    var secondPage: some View {
        VStack(alignment: .leading) {
            // Title categry picker
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

            }
            .padding(.horizontal)

            
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
            .listStyle(.plain)
            .sheet(isPresented: $showingPlayerView, content: {
                SoundPlayerView(sound: vm.selectedSound, purchasedRemoveAds: false)
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(storeManager: StoreManager())
            .environmentObject(HomeViewModel())
    }
}
    









