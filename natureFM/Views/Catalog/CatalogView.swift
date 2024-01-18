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
                .overlay(alignment: .bottom, content: {
                    if catalogVM.isViewingSongPlayerTab {
                        PlayingNowBar(playerVM: playerVM)
                            .environmentObject(catalogVM)
                    }
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
                    soundArray: catalogVM.allFreeSounds,
                    userLibrary: libraryVM.mySounds,
                    saveSoundToLibrary: libraryVM.saveSoundToLibrary,
                    tabSelection: $tabSelection
                )
     
                .frame(minHeight: UIScreen.main.bounds.height * 0.5)
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(storeManager.hasSubscription ? "Member" : "Free Listener")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(storeManager.hasSubscription ? "Thanks you for supporting natureFM" : "You could be missing out, get the subscription today for access to all content.")
                        Button("Get subscription") {
                            tabSelection = 2
                        }
                        .buttonStyle(BorderButton(color: Color.theme.titleColor))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
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
        }
        .edgesIgnoringSafeArea(.top)
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

