import SwiftUI

struct CatalogView: View {
    
    @ObservedObject var vm: HomeViewModel
    @ObservedObject var storeManager: StoreManager
    @ObservedObject var network: NetworkMonitor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ScrollView for main container
            if network.isConnected {
                ScrollView {
                    if let randomSound = vm.randomSound {
                        FeaturedImageLayoutView(
                            sound: randomSound,
                            storeManager: storeManager,
                            tabSelection: $vm.tabSelection
                        )
                    }
                    else {
                        Text("Loading...")
                    }
                        
                    // Sections Container
                    VStack(alignment: .leading) {
                        // Section One
              
                        HorizontalScrollView(
                            vm: vm,
                            soundChoice: .free,
                            storeManager: storeManager,
                            tabSelection: $vm.tabSelection
                        )
                        // Section Three
                        HorizontalScrollView(
                            vm: vm,
                            soundChoice: .subscription,
                            storeManager: storeManager,
                            tabSelection: $vm.tabSelection
                        )
                        .padding(.bottom, 25)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .sheet(isPresented: $vm.isViewingSongPlayer, content: {
                    SoundPlayerView()
                        .environmentObject(vm)
                })
                .overlay(alignment: .bottom, content: {
                        if vm.isViewingSongPlayerTab {
                            PlayingNowBar()
                                .environmentObject(vm)
                        }
                    }
                )
            } else {
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
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView(
            vm: HomeViewModel(),
            storeManager: StoreManager(),
            network: NetworkMonitor()
        )
    }
}
