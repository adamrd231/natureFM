import SwiftUI

struct FeaturedImageLayoutView: View {
    // Passed parameters
    @ObservedObject var catalogVM: CatalogViewModel
    @ObservedObject var libraryVM: LibraryViewModel
    let userHasSubscription: Bool
    // State variables
    @State private var isShowingAlert: Bool = false
    @Binding var tabSelection: Int
    @State var previewTabSelection: Int = 1
    
    var body: some View {
        TabView(selection: $previewTabSelection) {
            if let error = catalogVM.hasError {
                ErrorView(error: error)
            } else if catalogVM.isLoadingSounds {
               LoadingFullScreenView()
            } else {
                ForEach(catalogVM.allSounds, id: \.id) { sound in
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
                                
                            if libraryVM.mySounds.contains(sound) {
                                Text("In your library")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            } else {
                                Button("Download") {
                                    if userHasSubscription || sound.freeSong {
                                        libraryVM.saveSoundToLibrary(sound)
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
                    .tag(sound.id)
                    .frame(width: UIScreen.main.bounds.width)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.default, value: previewTabSelection)
        .frame(minHeight: UIScreen.main.bounds.height * 0.5)
//        .edgesIgnoringSafeArea(.top)
    }
}

struct FeaturedImageLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedImageLayoutView(
            catalogVM: dev.homeVM,
            libraryVM: dev.libraryVM,
            userHasSubscription: false,
            tabSelection: .constant(1)
        )
    }
}
