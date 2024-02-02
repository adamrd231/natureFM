import SwiftUI

struct CatalogSoundsView: View {
    @ObservedObject var catalogVM: CatalogViewModel
    @ObservedObject var libraryVM: LibraryViewModel
    let hasSubscription: Bool
    // Tab selection
    @Binding var tabSelection: Int


    var body: some View {
        VStack(alignment: .leading) {
            CatalogTitle(title: "Catalog")
            CatalogSubtitle(text: "Browse white noise inspired from nature")
            VStack(spacing: 15) {
                ForEach(catalogVM.filteredSounds, id: \.id) { sound in
                    CatalogSoundView(
                        sound: sound,
                        hasSubscription: hasSubscription,
                        libraryVM: libraryVM,
                        tabSelection: $tabSelection
                    )
                    
                }
                .listStyle(.plain)
            }
        }
        .padding(.leading)
    }
}

struct CatalogSoundsView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogSoundsView(
            catalogVM: dev.homeVM,
            libraryVM: dev.libraryVM,
            hasSubscription: false,
            tabSelection: .constant(1)
        )
    }
}
