import SwiftUI

struct CatalogSoundsView: View {
    @ObservedObject var catalogVM: CatalogViewModel
    let hasSubscription: Bool
    // Tab selection
    @Binding var tabSelection: Int


    var body: some View {
        VStack(alignment: .leading) {
            CatalogTitle(title: "Catalog")
            CatalogSubtitle(text: "Browse white noise inspired from nature")
            ForEach(catalogVM.allSounds, id: \.id) { sound in
                CatalogSoundView(sound: sound) 
                
            }
            .listStyle(.plain)
        }
        .padding(.leading)
    }
}

struct CatalogSoundsView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogSoundsView(
            catalogVM: dev.homeVM,
            hasSubscription: false,
            tabSelection: .constant(1)
        )
    }
}
