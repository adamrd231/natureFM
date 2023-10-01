import SwiftUI

struct HorizontalScrollView: View {
    
    @EnvironmentObject var vm: HomeViewModel

    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    var soundArray: [SoundsModel]
    
    @Binding var audioPlayerCurrentSong: SoundsModel?
    @Binding var isShowingAudioPlayer: Bool
    @Binding var isShowingAudioPlayerTab: Bool
    @Binding var isPlaying: Bool
    
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
                                        .frame(width: 185, height: 117)
                                }
                            }
                        }
                    }
                    else {
                        ForEach(soundArray) { sound in
                            VStack(alignment: .leading, spacing: 10) {
                                SoundImageView(sound: sound)
                                    .frame(width: 185, height: 117)
                                    .clipped()
                                    .shadow(radius: 2)
                                   
                                HStack {
            
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
                                            print("Show player")
                                            print("Sound: \(sound)")
                                            audioPlayerCurrentSong = sound
                                
                                            isShowingAudioPlayerTab = true
                                            print("isAudioTab = \(isShowingAudioPlayerTab)")
                                        }) {
                                            Text(sound.name).font(.subheadline)
                                        }
                                       
                                        Text(sound.freeSong ? "Free" : "Subscription")
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 5)
                                            .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue)
                                            
                                       
                                    }
                                    .alert(isPresented: $showingAlert, content: {
                                        // decide which alert to show
                                       return subscriptionNotPurchasedAlert
                                        
                                    })
                                    .foregroundColor(Color.theme.titleColor)
                                    Spacer()
                                }
                            }.padding(.trailing, 3)
                        }
                    }
                }
            }
        }
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(
            storeManager: StoreManager(),
            soundArray: [],
            audioPlayerCurrentSong: .constant(SoundsModel()),
            isShowingAudioPlayer: .constant(false),
            isShowingAudioPlayerTab: .constant(false),
            isPlaying: .constant(false)
        )
            .environmentObject(HomeViewModel())
    }
}
