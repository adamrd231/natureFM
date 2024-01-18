import SwiftUI

struct FeaturedImageLayoutView: View {
    let soundArray: [SoundsModel]
    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    @State private var isShowingAlert: Bool = false
    @Binding var tabSelection: Int
    
    var body: some View {
        TabView {
            ForEach(soundArray, id: \.id) { sound in
                ZStack {
                    SoundImageView(sound: sound)
                        .overlay(Color.black.opacity(0.5))
                    
                    VStack(alignment: .center, spacing: 3) {
                        Text(sound.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(sound.locationName)
                            .font(.caption)
                        Text(sound.freeSong ? "Free" : "Subscription")
                            .padding(3)
                            .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue )
                    }
                    .foregroundColor(Color.theme.backgroundColor)
                    .alert(isPresented: $isShowingAlert, content: {
                        // decide which alert to show
                        Alert(
                            title: Text("Currently not available"),
                            message: Text("You must have a subscription for this premium content."),
                            primaryButton: .default(Text("Store")) {
                                tabSelection = 3
                            },
                            secondaryButton: .cancel(Text("No thanks"))
                        )
                    })
                }
                .frame(width: UIScreen.main.bounds.width)
                .frame(minWidth: 0, maxWidth: .infinity)

            }
        }
        .tabViewStyle(.page)
        .edgesIgnoringSafeArea(.top)
    }
}

struct FeaturedImageLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedImageLayoutView(
            soundArray: dev.homeVM.allFreeSounds,
            storeManager: StoreManager(),
            tabSelection: .constant(1)
        )
    }
}
