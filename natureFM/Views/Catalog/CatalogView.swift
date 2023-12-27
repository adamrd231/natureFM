import SwiftUI

struct CatalogTitle: View {
    let title: String
    let color: Color?
    
    init(title: String, color: Color? = nil) {
        self.title = title
        self.color = color
    }
    var body: some View {
        Text(title)
//            .padding(.leading)
            .foregroundColor(color)
            .font(.title2)
            .fontWeight(.bold)
    }
}

struct CatalogView: View {
    
    @ObservedObject var vm = HomeViewModel()
    @ObservedObject var storeManager = StoreManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                // ScrollView for main container
                ScrollView {
                    HeaderView(natureCoins: vm.natureFMCoins)
                        .edgesIgnoringSafeArea(.all)
                    // Sections Container
                    VStack(alignment: .leading) {
                        // Section One
              
                        HorizontalScrollView(
                            vm: vm,
                            soundChoice: .free,
                            storeManager: storeManager,
                            tabSelection: $vm.tabSelection
                        )
                        
                        VStack(alignment: .leading) {
                            Text("About Nature FM").bold()
                            Text("Nature FM is inspired directly from being outside, the sense of calm and serenity can fill you up if you can slow down, close your eyes and listen. Nature is always producing symphonies of beauty. Nature FM collects these sounds, and gathers them here in this app for users to connect to waves, wind, thunderstorms, or a part of the country they are longing for.").font(.caption)
                        }
                        .foregroundColor(Color.theme.titleColor)
                        .padding()
                        
                        // Section Two
                        if let randomSound = vm.allSounds.randomElement() {
                            FeaturedImageLayoutView(
                                sound: randomSound,
                                storeManager: storeManager,
                                tabSelection: $vm.tabSelection
                            )
                            .padding()
                        }

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
            if storeManager.isShowingAdvertising {
                AdmobBanner()
            }
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
