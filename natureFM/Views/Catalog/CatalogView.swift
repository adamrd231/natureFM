import SwiftUI

struct CatalogView: View {
    @ObservedObject var catalogVM: CatalogViewModel
    @ObservedObject var playerVM: PlayerViewModel
    @ObservedObject var libraryVM: LibraryViewModel
    @ObservedObject var storeManager: StoreManager
    @ObservedObject var network: NetworkMonitor
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if network.isConnected {
                CatalogScrollView
            } else {
                NoInternetView
            }
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView(
            catalogVM: dev.homeVM,
            playerVM: PlayerViewModel(),
            libraryVM: LibraryViewModel(),
            storeManager: StoreManager(),
            network: NetworkMonitor(),
            tabSelection: .constant(1)
        )
    }
}

extension CatalogView {
    var CatalogScrollView: some View {
        VStack {
            ScrollView {
                VStack(spacing: 25) {
                    FeaturedImageLayoutView(
                        soundArray: catalogVM.allSounds,
                        userLibrary: libraryVM.mySounds,
                        saveSoundToLibrary: libraryVM.saveSoundToLibrary,
                        tabSelection: $tabSelection
                    )
            
                    UserListenerStatusView(
                        hasSubscription: storeManager.hasSubscription,
                        tabSelection: $tabSelection)
                    
                    CategoryRowView(
                        categories: catalogVM.categories,
                        selectedCategory: $catalogVM.selectedCategory
                    )
     
                    // Section One
                    HorizontalScrollView(
                        soundArray: catalogVM.allFreeSounds,
                        userLibrary: libraryVM.mySounds,
                        isViewingSongPlayerTab: $playerVM.isViewingSongPlayerTab,
                        soundChoice: .free,
                        hasSubscription: storeManager.hasSubscription,
                        tabSelection: $tabSelection
                    )
                    // Section Three
                    HorizontalScrollView(
                        soundArray: catalogVM.allSubscriptionSounds,
                        userLibrary: libraryVM.mySounds,
                        isViewingSongPlayerTab: $playerVM.isViewingSongPlayerTab,
                        soundChoice: .subscription,
                        hasSubscription: storeManager.hasSubscription,
                        tabSelection: $tabSelection
                    )
                }
                .overlay(alignment: .topLeading) {
                    Text("natureFM")
                        .foregroundColor(Color.theme.titleColor)
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .padding(25)
                        .padding(.top, 25)
                }

            }
            
            if playerVM.isViewingSongPlayerTab {
                PlayingNowBar(playerVM: playerVM)
            }
        }
    }
    
    
    
    var NoInternetView: some View {
        VStack(alignment: .center) {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 25, height: 25)
            Text("No internet connection available")
                .bold()
            Text("To view sounds and download items from the library, please connect to wifi or cellular data.")
                .font(.caption)
            Button {
                tabSelection = 2
            } label: {
                Text("Library")
            }
            .tint(Color.black.opacity(0.4))
            .buttonStyle(.bordered)

        }
        .padding()
        .background(Color.theme.backgroundColor)
        .foregroundColor(Color.theme.titleColor)
        .cornerRadius(10)
        .padding()
        .multilineTextAlignment(.center)
    }
}

