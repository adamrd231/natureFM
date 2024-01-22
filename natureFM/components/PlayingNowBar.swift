import SwiftUI

struct PlayingNowBar: View {
    @ObservedObject var playerVM: PlayerViewModel
    
    let buttonSize: CGFloat = 25
    
    var body: some View {
        HStack(spacing: 15) {
            if let sound = playerVM.sound {
                SoundImageView(sound: sound)
                    .frame(height: 80)
                    .frame(maxWidth: 90)
                    .clipped()
                    .overlay(alignment: .topLeading) {
                        Button {
                            playerVM.stopPlayer()
                            playerVM.isViewingSongPlayerTab = false
                        } label: {
                            Image(systemName: "cross.circle.fill")
                                .rotationEffect(Angle(degrees: 45))
                                .foregroundColor(Color.theme.titleColor.opacity(0.8))
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding(7)
                        }
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(sound.name)
                        .font(.callout)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.titleColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                
                    HStack(spacing: 5) {
                        ClockDisplayView(
                            time: Int(Double(playerVM.duration) - playerVM.currentTime),
                            font: .caption2
                        )
                    }
                }
                .font(.caption2)

            } else {
                Text("Loading")
            }
            
            

            Spacer()

            HStack(spacing: 25) {
                // Play button
                Button {
                    if playerVM.isPlaying {
                        playerVM.stopPlayer()
                    } else {
                        playerVM.startPlayer()
                    }
                   
                } label: {
                    if let player = playerVM.audioPlayer {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: buttonSize, height: buttonSize, alignment: .center)
                    } else {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: buttonSize, height: buttonSize, alignment: .center)
                    }
                }
//                if homeVM.allSounds.count > 1 {
//                    Button {
////                        homeVM.skipToNextSound()
//                    } label: {
//                        Image(systemName: "forward.end")
//                            .resizable()
//                            .frame(width: buttonSize - 5, height: buttonSize - 5, alignment: .center)
//                    }
//                }
            }
            .foregroundColor(Color.theme.customBlue)
            .padding(.trailing)
            
        }
        .onTapGesture {
            playerVM.isViewingSongPlayer = true
        }

        .frame(width: UIScreen.main.bounds.width, height: 80)
        .background(Color.theme.backgroundColor.opacity(0.9))
    }

}
//
struct PlayingNowBar_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayingNowBar(
            playerVM: dev.playerVM
        )
        .preferredColorScheme(.light)
        .environmentObject(dev.homeVM)
        .previewLayout(.sizeThatFits)
    }
}
