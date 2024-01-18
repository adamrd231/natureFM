import SwiftUI

enum SoundChoices {
    case free
    case subscription
}

struct HorizontalScrollView: View {
    @ObservedObject var vm: CatalogViewModel
    @ObservedObject var playerVM: PlayerViewModel
    let soundChoice: SoundChoices

    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    
    // Tab selection
    @Binding var tabSelection: Int
    var soundArray: [SoundsModel] {
        switch soundChoice {
        case .free: return vm.allFreeSounds
        case .subscription: return vm.allSubscriptionSounds
        }
    }
    
    @State private var showingAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            CatalogTitle(title: soundChoice == .free ? "Free sounds" : "Premium stuff")
            CatalogSubtitle(text: soundChoice == .free ? "Free sounds" : "Premium stuff")
            HStack(spacing: 50) {
                ScrollView(.horizontal) {
                    HStack {
                        if soundArray.count == 0 {
                            HStack(spacing: 10) {
                                ForEach(0..<Int.random(in: 1...3), id: \.self) { _ in
                                    ZStack {
                                        ProgressView()
                                        Rectangle()
                                            .foregroundColor(.gray)
                                            .opacity(0.1)
                                            .frame(width: 200, height: 120)
                                    }
                                }
                            }
                        }
                        else {
                            ForEach(soundArray, id: \.id) { sound in
                                VStack(alignment: .leading, spacing: 10) {
                                    SoundImageView(sound: sound)
                                        .frame(width: 200, height: 120)
                                        .clipped()

                                    HStack(spacing: 5) {
                                        Button(action: {
                                            let isSoundFree = sound.freeSong
                                            let userHasSubscription = !storeManager.products.contains(where: { $0.id == StoreIDs.NatureFM })
                                            
                                            if isSoundFree || userHasSubscription {
                                                // Download sound is allowed
                                            } else {
                                                showingAlert.toggle()
                                                // Could prompt user to subscription page
                                            }
                                        }) {
                                            Image(systemName: "arrow.down.circle.fill")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                        }
                                        .foregroundColor(Color.theme.titleColor)
                                        
                                        VStack(alignment: .leading) {
                                            Button(action: {
                                                // select song and play
                                                if sound.freeSong || storeManager.purchasedSubscriptions.contains(where: { $0.id == StoreIDs.NatureFM }) {
                                                    
                                                    playerVM.sound = sound
                                                    vm.isViewingSongPlayerTab = true
                                                } else {
                                                    showingAlert = true
                                                }
                                              

                                            }) {
                                                VStack(alignment: .leading) {
                                                    Text(sound.name).font(.subheadline)
                                                    Text(sound.freeSong ? "Free" : "Subscription")
                                                        .font(.caption2)
                                                        .fontWeight(.bold)
                                                        .padding(.horizontal, 5)
                                                        .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue)
                                                }
                                            }
                                        }
                                        .alert(isPresented: $showingAlert, content: {
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
                                        .foregroundColor(Color.theme.titleColor)
                                    }
                                }
                                .frame(maxWidth: 200)
                            }
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
            vm: CatalogViewModel(),
            playerVM: PlayerViewModel(),
            soundChoice: .free,
            storeManager: StoreManager(),
            tabSelection: .constant(1)
        )
    }
}
