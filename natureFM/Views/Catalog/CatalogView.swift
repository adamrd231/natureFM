import SwiftUI

struct CatalogView: View {
    @ObservedObject var catalogVM: CatalogViewModel
    @ObservedObject var libraryVM: LibraryViewModel
    @ObservedObject var storeManager: StoreManager
    @ObservedObject var network: NetworkMonitor
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if network.isConnected {
                CatalogScrollView
            } else {
                NoInternetView(tabSelection: $tabSelection)
            }
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView(
            catalogVM: dev.homeVM,
            libraryVM: LibraryViewModel(),
            storeManager: StoreManager(),
            network: NetworkMonitor(),
            tabSelection: .constant(1)
        )
    }
}

extension CatalogView {
    var CatalogScrollView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 25) {
                    FeaturedImageLayoutView(
                        soundArray: catalogVM.allSounds,
                        userLibrary: libraryVM.mySounds,
                        saveSoundToLibrary: libraryVM.saveSoundToLibrary,
                        userHasSubscription: storeManager.hasSubscription,
                        isLoading: catalogVM.isLoadingSounds,
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
                    CatalogSoundsView(
                        catalogVM: catalogVM,
                        libraryVM: libraryVM,
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
            
            if libraryVM.isViewingSongPlayerTab {
                PlayingNowBar(libraryVM: libraryVM)
              
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

