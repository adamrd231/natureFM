import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var catalogVM: CatalogViewModel
    @ObservedObject var libraryVM: LibraryViewModel
    @ObservedObject var storeManager: StoreManager
    @Binding var currentTab: Int

    var body: some View {
        VStack(alignment: .leading) {
            // Title categry picker
            ScrollView(.horizontal) {
                VStack {
                    HStack(spacing: 15) {
                        ForEach(libraryVM.categories) { category in
                            Text("\(category.title)")
                                .fontWeight((category.title == libraryVM.selectedCategory) ? .medium : .light)
             
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
                        selectSound: libraryVM.selectSound,
                        removeFromLibrary: libraryVM.removeFromLibrary,
                        isViewingTabPlayerView: $libraryVM.isViewingSongPlayerTab,
                        isViewingFullPlayerView: $libraryVM.isViewingSongPlayer
                    )
                }
                .listRowSeparator(.hidden)
                VStack(alignment: .leading) {
                    Text("Need more sounds?").bold()
                    Button {
                        currentTab = 1
                    } label: {
                        Text("Head to catalog")
                    }
                    .foregroundColor(Color.theme.customBlue)
                    .buttonStyle(.borderless)
                }
            }
            .listStyle(.plain)
 

            if libraryVM.isViewingSongPlayerTab {
                PlayingNowBar(libraryVM: libraryVM)
            }
        }
        .fullScreenCover(isPresented: $libraryVM.isViewingSongPlayer, content: {
            SoundPlayerView(
                libraryVM: libraryVM,
                tabSelection: $currentTab
            )
        })
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(
            libraryVM: dev.libraryVM,
            storeManager: StoreManager(),
            currentTab: .constant(1)
        )
        .environmentObject(dev.homeVM)
    }
}
