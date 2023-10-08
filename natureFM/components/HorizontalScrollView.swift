import SwiftUI

enum SoundChoices {
    case free
    case subscription
}

struct HorizontalScrollView: View {
    @EnvironmentObject var vm: HomeViewModel
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    let soundChoice: SoundChoices

    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    var soundArray: [SoundsModel] {
        switch soundChoice {
        case .free: return vm.allFreeSounds
        case .subscription: return vm.allSubscriptionSounds
        }
        
    }
    
    @State private var showingAlert: Bool = false
    
    var subscriptionNotPurchasedAlert = Alert(
        title: Text("Not Available."),
        message: Text("You must have a subscription to access this premium content."),
        dismissButton: .default(Text("Done")))

    var body: some View {
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
                        ForEach(soundArray) { sound in
                            VStack(alignment: .leading, spacing: 10) {
//                                SoundImageView(sound: sound)
                          
                                AsyncImage(
                                    url: URL(string: sound.imageFileLink),
                                    content: { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .contentShape(Rectangle())
                                            .frame(width: 200, height: 120)
                                            .clipped()
                                        
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(Color.theme.backgroundColor)
                                                .frame(width: 200, height: 120)
                                            ProgressView()
                                        }
                                       
                                    }
     
                                HStack(spacing: 5) {
                                    Button(action: {
                                        // TODO: Check if content requires premium membership
                                        // TODO: Perform check and allow or throw alert
                                            vm.downloadedContentService.saveSound(sound: sound)
                                        
                                    }) {
                                        Image(systemName: "arrow.down.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    }
                                    .foregroundColor(Color.theme.titleColor)
                                    
                                    VStack(alignment: .leading) {
                                        Button(action: {
                                            // select song and play
                                            soundVM.sound = sound
                                            vm.isViewingSongPlayerTab = true
                                   
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
                                       return subscriptionNotPurchasedAlert
                                        
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
        .padding(.leading)
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(
            soundChoice: .free,
            storeManager: StoreManager()
        )
        .environmentObject(dev.homeVM)
        .environmentObject(dev.soundVM)
    }
}
