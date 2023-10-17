import SwiftUI
import GoogleMobileAds
import Combine

struct HomeView: View {
    // View model for home / getting sounds
    @StateObject var vm = HomeViewModel()
    // Store manager / in app purchases and subscriptions
    @StateObject var storeManager = StoreManager()

    // Variable to control when to show the player view
    @State var showingPlayerView: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        TabView(selection: $vm.tabSelection) {
            // Home View
            homeView
                .tabItem {
                    TabItemView(text: "Browse", image: "antenna.radiowaves.left.and.right")
                }
                .tag(1)
            
            // Library View
            LibraryView()
                .environmentObject(vm)
                .tabItem {
                    TabItemView(text: "Library", image: "music.note.house")
                }
                .tag(2)
            
            // In App Purchases
            InAppStorePurchasesView(
                storeManager: storeManager
            )
                .environmentObject(vm)
                .tabItem {
                    TabItemView(text: "In-App Purchases", image: "creditcard")
                }
                .tag(3)
                
            // User profile and App Information
            ProfileView(storeManager: storeManager)
                .environmentObject(vm)
                .tabItem {
                    TabItemView(text: "About", image: "person.crop.circle")
                }
                .tag(4)
        }
        .tint(Color.theme.customBlue)
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

extension HomeView {
    
    // MARK: Page Views
    var homeView: some View {
        VStack(alignment: .leading, spacing: 0) {

                // ScrollView for main container
                ScrollView {
                    HeaderView(natureCoins: vm.natureFMCoins)
                        .edgesIgnoringSafeArea(.all)
                    // Sections Container
                    VStack(alignment: .leading) {
                        // Section One
                        Text("Listen now")
                            .padding(.leading)
                            .foregroundColor(Color.theme.titleColor)
                            .font(.title2)
                            .fontWeight(.bold)
                        HorizontalScrollView(
                            soundChoice: .free,
                            storeManager: storeManager,
                            tabSelection: $vm.tabSelection
                        )
                        .environmentObject(vm)
                        
                        VStack(alignment: .leading) {
                            Text("About Nature FM").bold()
                            Text("Nature FM is inspired directly from being outside, the sense of calm and serenity can fill you up if you can slow down, close your eyes and listen. Nature is always producing symphonies of beauty. Nature FM collects these sounds, and gathers them here in this app for users to connect to waves, wind, thunderstorms, or a part of the country they are longing for.").font(.caption)
                        }
                        .foregroundColor(Color.theme.titleColor)
                        .padding()
                        
                        // Section Two
                        if let randomSound = vm.allSounds.randomElement() {
                            FeaturedImageLayoutView(
                                sound: randomSound,
                                storeManager: storeManager,
                                tabSelection: $vm.tabSelection
                            )
                            .padding()
                        }

                        // Section Three
                        Text("Tickets, please.")
                            .foregroundColor(Color.theme.titleColor)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                        HorizontalScrollView(
                            soundChoice: .subscription,
                            storeManager: storeManager,
                            tabSelection: $vm.tabSelection
                        )
                        .environmentObject(vm)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .sheet(isPresented: $vm.isViewingSongPlayer, content: {
                    SoundPlayerView()
                        .environmentObject(vm)
                        .presentationDetents([.large])
                    
                })
                .overlay(alignment: .bottom, content: {
                        if vm.isViewingSongPlayerTab {
                            PlayingNowBar()
                                .environmentObject(vm)
                        }
                    }
                )
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())

    }
}
    









