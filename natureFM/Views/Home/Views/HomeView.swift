import SwiftUI
import GoogleMobileAds
import Combine

struct HomeView: View {
    // View model for home / getting sounds
    @StateObject var vm = HomeViewModel()
    // Store manager / in app purchases and subscriptions
    @StateObject var storeManager = StoreManager()
    // Advertising viewmodel
    @ObservedObject var adsViewModel = AdvertisingViewModel()
    
    @StateObject var networkMonitor = NetworkMonitor()

    // Variable to control when to show the player view
    @State var showingPlayerView: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        TabView(selection: $vm.tabSelection) {
            // Home View
            CatalogView(
                vm: vm,
                storeManager: storeManager,
                network: networkMonitor
            )
                .tabItem {
                    TabItemView(text: "Browse", image: "antenna.radiowaves.left.and.right")
                }
                .tag(1)
                .onAppear {
                    if storeManager.isShowingAdvertising {
                        adsViewModel.interstitialCount += 1
                    }
                }
            
            // Library View
            LibraryView(
                storeManager: storeManager
            )
                .environmentObject(vm)
                .tabItem {
                    TabItemView(text: "Library", image: "music.note.house")
                }
                .onAppear {
                    if storeManager.isShowingAdvertising {
                        #if DEBUG
                        #else
                        adsViewModel.interstitialCount += 1
                        #endif
                    }
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
    









