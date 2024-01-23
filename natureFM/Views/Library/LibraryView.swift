import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var catalogVM: CatalogViewModel
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
                VStack {
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
                    Divider()
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
                ForEach(libraryVM.filteredSounds) { sound in
                    LibraryItemView(
                        sound: sound,
                        removeFromLibrary: libraryVM.removeFromLibrary
                    )
                }
           
            }
            .listStyle(.plain)

            if playerVM.isViewingSongPlayerTab {
                PlayingNowBar(playerVM: playerVM)
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
