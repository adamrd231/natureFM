import SwiftUI

enum SoundChoices {
    case free
    case subscription
}

struct HorizontalScrollView: View {
    let soundArray: [SoundsModel]
    let userLibrary: [SoundsModel]
    let downloadSoundToLibrary: (SoundsModel) -> Void
    @Binding var isViewingSongPlayerTab: Bool
    let soundChoice: SoundChoices
    let hasSubscription: Bool
    // Tab selection
    @Binding var tabSelection: Int


    var body: some View {
        VStack(alignment: .leading) {
            CatalogTitle(title: soundChoice == .free ? "Free sounds" : "Premium stuff")
            CatalogSubtitle(text: soundChoice == .free ? "Free sounds" : "Premium stuff")
            HStack(spacing: 50) {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(soundArray, id: \.id) { sound in
                            HorizontalScrollSoundView(
                                sound: sound,
                                hasSubscription: hasSubscription,
                                userOwnsSound: userLibrary.contains(where: { $0.name == sound.name }),
                                downloadSoundToLibrary: downloadSoundToLibrary,
                                isViewingSongPlayerTab: $isViewingSongPlayerTab,
                                tabSelection: $tabSelection
                            )
                        }
                    }
                }
            }
        }
        .padding(.leading)
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(
            soundArray: [dev.testSound, dev.testSound2],
            userLibrary: [dev.testSound],
            downloadSoundToLibrary: { _ in },
            isViewingSongPlayerTab: .constant(false),
            soundChoice: .free,
            hasSubscription: false,
            tabSelection: .constant(1)
        )
    }
}
