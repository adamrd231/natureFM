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
                    .sheet(isPresented: $catalogVM.isViewingSongPlayer, content: {
                        SoundPlayerView(
                            homeVM: catalogVM,
                            playerVM: playerVM,
                            tabSelection: $tabSelection
                        )
                    })
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
                    vm: catalogVM,
                    playerVM: playerVM,
                    soundChoice: .free,
                    storeManager: storeManager,
                    tabSelection: $tabSelection
                )
                // Section Three
                HorizontalScrollView(
                    vm: catalogVM,
                    playerVM: playerVM,
                    soundChoice: .subscription,
                    storeManager: storeManager,
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
        .edgesIgnoringSafeArea(.top)
        .overlay(alignment: .bottom, content: {
            if catalogVM.isViewingSongPlayerTab {
                PlayingNowBar(playerVM: playerVM)
                    .environmentObject(catalogVM)
            }
        })
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

