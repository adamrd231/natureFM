import SwiftUI

struct CatalogView: View {
    
    @ObservedObject var vm = HomeViewModel()
    @ObservedObject var storeManager = StoreManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // ScrollView for main container
            ScrollView {
                if let randomSound = vm.randomSound {
                    FeaturedImageLayoutView(
                        sound: randomSound,
                        storeManager: storeManager,
                        tabSelection: $vm.tabSelection
                    )
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
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView(
            vm: HomeViewModel(),
            storeManager: StoreManager()
        )
    }
}
