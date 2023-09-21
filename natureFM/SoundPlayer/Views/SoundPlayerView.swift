import SwiftUI
import AVKit

struct SoundPlayerView: View {
    
    @State var audioPlayer = AVAudioPlayer()
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var playerVM: SoundPlayerViewModel
    
    var purchasedRemoveAds: Bool
    @State var currentTime: Double = 0
    @State var sliderCurrentTime: Double = 0
    
    
    init(sound: SoundsModel, purchasedRemoveAds: Bool) {
        _playerVM = StateObject(wrappedValue: SoundPlayerViewModel(sound: sound))
        self.purchasedRemoveAds = purchasedRemoveAds
    }
    
    func returnRemainingTime() -> Text {
        let remainingTime = (playerVM.audioPlayer.duration) - currentTime
        return Text("Time Remaining: \(remainingTime.returnClockFormatAsString())")
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Text(playerVM.sound.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.down")
                    }
                    
                    .foregroundColor(Color.theme.customBlue)
                    
                }.padding(.horizontal).padding(.top)
                
                VStack {
                    SoundImageView(sound: playerVM.sound)
                        
                        .frame(width: geo.size.width, height: geo.size.height * 0.55)
                        .clipped()
                   

                }
                
                
                
                
                // Sound Player tracker.
                VStack {
                    if let totalTime = Double(playerVM.audioPlayer.duration) {
                        Slider(value: $currentTime, in: 0...totalTime, onEditingChanged: { val in
                            print("Value changed \(val)")
                            playerVM.audioPlayer.currentTime = currentTime
                        })
                        .accentColor(Color.theme.customBlue)
                        .onChange(of: totalTime, perform: { value in
                            print("tapped")
                        })
                   
                    }
                    HStack {
                        Text("\(currentTime.returnClockFormatAsString())")
                            
                        Spacer()
                        returnRemainingTime()
                        Spacer()
                        Text("\(playerVM.audioPlayer.duration.returnClockFormatAsString())")
                        
                    }.font(.caption)
                }
                .padding(.horizontal)
                .onReceive(playerVM.timer, perform: { _ in
                    self.currentTime = playerVM.audioPlayer.currentTime
       
                })
               
                
                
                HStack(spacing: 25) {
                    Button(action: {
                        if playerVM.audioPlayer.currentTime < 30 {
                            playerVM.audioPlayer.currentTime = 0
                        } else {
                            playerVM.audioPlayer.currentTime -= 30
                        }
                        
                    }) {
                        Image(systemName: "gobackward.30")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    
                    Button(action: {
                        playerVM.startStopAudioPlayer()
                    }) {
                        playerVM.audioIsPlaying ? Image(systemName: "pause.circle.fill").resizable() : Image(systemName: "play.circle.fill").resizable()
                        
                    }
                    .frame(width: 50, height: 50)

                    Button(action: {
                        self.currentTime = 0
                        playerVM.skipForwardThirtySeconds()
                        
                    }) {
                        Image(systemName: "goforward.30")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }.foregroundColor(Color.theme.customBlue)
   
       
            }
            
        }.onDisappear(perform: {
            playerVM.stopAudioPlayer()
        })
        
       
    }
}

struct SoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerView(sound: SoundsModel(), purchasedRemoveAds: true)
    }
}
