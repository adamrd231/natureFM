import SwiftUI

struct FeaturedImageLayoutView: View {
    let soundArray: [SoundsModel]
    let userLibrary: [SoundsModel]
    var saveSoundToLibrary: (SoundsModel) -> Void
    let userHasSubscription: Bool
    let isLoading: Bool
    @State private var isShowingAlert: Bool = false
    @Binding var tabSelection: Int
    
    var body: some View {
        TabView {
            if isLoading {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.theme.backgroundColor.opacity(0.33))
                    VStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.theme.customBlue)
                        Text("Loading")
                            .fontWeight(.bold)
                            
                    }
                    .padding()
                    .background(Color.theme.backgroundColor.opacity(0.66))
                    .cornerRadius(15)
                }
  
                .foregroundColor(Color.theme.customBlue)
                
            } else {
                ForEach(soundArray, id: \.id) { sound in
                    ZStack {
                        SoundImageView(sound: sound)
                            .overlay(
                                LinearGradient(colors: [Color.theme.backgroundColor, Color.theme.backgroundColor.opacity(0)], startPoint: .top, endPoint: .bottom)
                            )
            
                        VStack(alignment: .center, spacing: 10) {
                            Text(sound.freeSong ? "Free" : "Requires Subscription")
                                .font(.caption)
                                .padding(3)
                                .background(sound.freeSong ? Color.theme.customBlue : Color.theme.customYellow)
                     
                            Text(sound.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.66)
                                .multilineTextAlignment(.center)
                                
                            if userLibrary.contains(sound) {
                                Text("In your library")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            } else {
                                Button("Download") {
                                    if userHasSubscription || sound.freeSong {
                                        saveSoundToLibrary(sound)
                                    } else {
                                        isShowingAlert = true
                                    }
                                }
                                .buttonStyle(BorderButton(color: Color.theme.titleColor))

                            }
                        }
                        .foregroundColor(Color.theme.titleColor)
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
                }
            }
            
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .edgesIgnoringSafeArea(.top)
        .frame(minHeight: UIScreen.main.bounds.height * 0.5)
    }
}

struct FeaturedImageLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedImageLayoutView(
            soundArray: dev.homeVM.allSounds,
            userLibrary: [],
            saveSoundToLibrary: { _ in dev.testSound },
            userHasSubscription: false,
            isLoading: true,
            tabSelection: .constant(1)
        )
    }
}
