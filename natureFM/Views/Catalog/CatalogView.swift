import SwiftUI

struct CatalogView: View {
    @ObservedObject var vm: HomeViewModel
    @ObservedObject var playerVM: PlayerViewModel
    @ObservedObject var storeManager: StoreManager
    @ObservedObject var network: NetworkMonitor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if network.isConnected {
                CatalogScrollView
                .sheet(isPresented: $vm.isViewingSongPlayer, content: {
                    SoundPlayerView(homeVM: vm, playerVM: playerVM)
                })
                .overlay(alignment: .bottom, content: {
                    if vm.isViewingSongPlayerTab {
                        PlayingNowBar(playerVM: playerVM)
                            .environmentObject(vm)
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
            vm: HomeViewModel(),
            playerVM: PlayerViewModel(),
            storeManager: StoreManager(),
            network: NetworkMonitor()
        )
    }
}

extension CatalogView {
    var CatalogScrollView: some View {
        ScrollView {
            if let randomSound = vm.randomSound {
                FeaturedImageLayoutView(
                    sound: randomSound,
                    storeManager: storeManager,
                    tabSelection: $vm.tabSelection
                )
            }
            // Section One
            HorizontalScrollView(
                vm: vm,
                playerVM: playerVM,
                soundChoice: .free,
                storeManager: storeManager,
                tabSelection: $vm.tabSelection
            )
            // Section Three
            HorizontalScrollView(
                vm: vm,
                playerVM: playerVM,
                soundChoice: .subscription,
                storeManager: storeManager,
                tabSelection: $vm.tabSelection
            )
            .padding(.bottom, 25)
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
                vm.tabSelection = 2
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
