import SwiftUI

struct BorderButton: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .font(.callout)
            .fontWeight(.bold)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .overlay(
                Capsule()
                    .strokeBorder(color, lineWidth: 1)
            )
    }
}

struct FeaturedImageLayoutView: View {
    let soundArray: [SoundsModel]
    let userLibrary: [SoundsModel]
    var saveSoundToLibrary: (SoundsModel) -> Void
    @State private var isShowingAlert: Bool = false
    @Binding var tabSelection: Int
    
    var body: some View {
        TabView {
            ForEach(soundArray, id: \.id) { sound in
                ZStack {
                    SoundImageView(sound: sound)
                        .overlay(Color.black.opacity(0.5))
                    
                    VStack(alignment: .center, spacing: 10) {
                        Text(sound.freeSong ? "Free" : "Requires Subscription")
                            .font(.caption)
                            .padding(3)
                            .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue )
                 
                        Text(sound.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.66)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.theme.backgroundColor)
                      
                        if userLibrary.contains(sound) {
                            Text("In your library")
                                .font(.caption)
                                .fontWeight(.bold)
                        } else {
                            Button("Download") {
                                saveSoundToLibrary(sound)
                            }
                            .buttonStyle(BorderButton(color: Color.theme.backgroundColor))
                            
                        }
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
            userLibrary: [],
            saveSoundToLibrary: { _ in dev.testSound },
            tabSelection: .constant(1)
        )
    }
}
