import SwiftUI

struct PlayingNowBar: View {
    @ObservedObject var playerVM: PlayerViewModel
    
    let buttonSize: CGFloat = 25
    
    var body: some View {
        HStack(spacing: 0) {
            if let sound = playerVM.sound {
                SoundImageView(sound: sound)
                    .frame(maxWidth: 90, maxHeight: 70)
                    .clipped()
                    .cornerRadius(10)
                    .padding()
                
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
                ProgressView()
            }
            
            Spacer()

            HStack(spacing: 25) {
                Button {
                    playerVM.isViewingSongPlayer = true
                    playerVM.isViewingSongPlayerTab = false
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }
                
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
            }
            .foregroundColor(Color.theme.customBlue)
            .padding(.trailing)
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 80)
    }

}
//
struct PlayingNowBar_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayingNowBar(
            playerVM: dev.playerVM
        )
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
}
