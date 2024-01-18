import SwiftUI
import GoogleMobileAds
import Combine

struct HomeView: View {
    // Viewmodels to manage app data and services
    @StateObject var catalogVM = CatalogViewModel()
    @StateObject var playerVM = PlayerViewModel()
    @StateObject var libraryVM = LibraryViewModel()
    @State var currentTab: Int = 1
    
    
    // Network monitor, store and advertising managers
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var storeManager = StoreManager()
    @ObservedObject var adsViewModel = AdvertisingViewModel()

    private var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        TabView(selection: $currentTab) {
            // Home View
            CatalogView(
                catalogVM: catalogVM,
                playerVM: playerVM,
                libraryVM: libraryVM,
                storeManager: storeManager,
                network: networkMonitor,
                tabSelection: $currentTab
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
                playerVM: playerVM,
                libraryVM: libraryVM,
                storeManager: storeManager,
                currentTab: $currentTab
            )
                .environmentObject(catalogVM)
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
                storeManager: storeManager,
                currentTab: $currentTab
            )
                .environmentObject(catalogVM)
                .tabItem {
                    TabItemView(text: "In-App Purchases", image: "creditcard")
                }
                .tag(3)
                
            // User profile and App Information
            ProfileView(storeManager: storeManager)
                .environmentObject(catalogVM)
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
            .environmentObject(CatalogViewModel())
    }
}
    









