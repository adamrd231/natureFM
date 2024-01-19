import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var vm: CatalogViewModel
    @ObservedObject var playerVM: PlayerViewModel
    @ObservedObject var libraryVM: LibraryViewModel
    @ObservedObject var storeManager: StoreManager
    @Binding var currentTab: Int
    
//    func delete(at offsets: IndexSet) {
//        if let index = offsets.first {
//            // delete sound
//        }
//    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title categry picker
            ScrollView(.horizontal) {
                HStack {
                    ForEach(libraryVM.categories) { category in
                        Text("\(category.title)")
                            .fontWeight((category.title == libraryVM.selectedCategory) ? .medium : .light)
                            .padding(.horizontal)
                            .offset(y: (category.title == libraryVM.selectedCategory) ? -2.0 : 0)
                            .scaleEffect((category.title == libraryVM.selectedCategory ? 1.5 : 1.0))
                            .onTapGesture {
                                libraryVM.selectedCategory = category.title
                            }
                    }
                }
                .padding()
            }
            
            HStack {
                Text("\(libraryVM.mySounds.count) Titles")
                    .foregroundColor(Color.theme.titleColor)
                    .fontWeight(.bold)
                Spacer()

            }
            .padding(.horizontal)
            
            List {
                ForEach(libraryVM.mySounds) { sound in
                    HStack(spacing: 10) {
                        SoundImageView(sound: sound)
                            .frame(width: 110, height: 75)
                            .clipped()
                            .shadow(radius: 3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(sound.name)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(sound.locationName)
                                .font(.footnote)
                            Text(sound.categoryName)
                                .font(.footnote)
                            HStack(spacing: 5) {
                                Text("Length:")
                                    .font(.footnote)
                                Text(sound.duration.returnClockFormatAsString())
                                    .font(.footnote)
                            }
                        }.foregroundColor(Color.theme.titleColor)
                    }
                   
                    .onTapGesture {
                        if !playerVM.isViewingSongPlayerTab {
                            playerVM.isViewingSongPlayerTab = true
                        }
                        playerVM.sound = sound
                    }
                }
           
            }
            .listStyle(.plain)
            .sheet(isPresented: $playerVM.isViewingSongPlayer, content: {
                SoundPlayerView(
                    homeVM: vm,
                    playerVM: playerVM,
                    tabSelection: $currentTab
                )
                
            })
            .overlay(alignment: .bottom, content: {
                    if playerVM.isViewingSongPlayerTab {
                        PlayingNowBar(playerVM: playerVM)
                            .environmentObject(vm)
                    }
                }
            )
            if storeManager.isShowingAdvertising {
                #if DEBUG
                #else
                AdmobBanner()
                #endif
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(
            playerVM: PlayerViewModel(),
            libraryVM: LibraryViewModel(),
            storeManager: StoreManager(),
            currentTab: .constant(1)
        )
        .environmentObject(dev.homeVM)
    }
}
