import SwiftUI
import GoogleMobileAds

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    @StateObject var soundVM = SoundPlayerViewModel()

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
            LibraryView()
                .environmentObject(vm)
                .environmentObject(soundVM)
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
                        HorizontalScrollView(
                            soundChoice: .free,
                            storeManager: storeManager
                        )
                        .environmentObject(vm)
                        .environmentObject(soundVM)
                        
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
                        HorizontalScrollView(
                            soundChoice: .subscription,
                            storeManager: storeManager
                        )
                        .environmentObject(vm)
                        .environmentObject(soundVM)
                    }
            }
            .sheet(isPresented: $vm.isViewingSongPlayer, content: {
                SoundPlayerView()
                    .environmentObject(soundVM)
                    .environmentObject(vm)
                    .presentationDetents([.medium, .large])
                
            })
            .overlay(alignment: .bottom, content: {
                    if vm.isViewingSongPlayerTab {
                        PlayingNowBar()
                            .environmentObject(soundVM)
                            .environmentObject(vm)
                    }
                }
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            soundVM: SoundPlayerViewModel(),
            storeManager: StoreManager()
        )
            .environmentObject(HomeViewModel())

    }
}
    









