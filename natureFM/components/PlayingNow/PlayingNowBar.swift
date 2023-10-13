import SwiftUI

struct PlayingNowBar: View {
    @EnvironmentObject var homeVM: HomeViewModel
    let buttonSize: CGFloat = 25
    
    var body: some View {
        HStack(spacing: 15) {
            if let sound = homeVM.sound {
                // This image needs to update based on current sound selection...
                SoundImageView(sound: sound)
                    .frame(height: 80)
                    .frame(maxWidth: 90)
                    .clipped()
                    .overlay(alignment: .topLeading) {
                        Button {
                            homeVM.isViewingSongPlayerTab = false
                        } label: {
                            Image(systemName: "cross.circle.fill")
                                .rotationEffect(Angle(degrees: 45))
                                .foregroundColor(Color.theme.titleColor.opacity(0.8))
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding(7)
                        }
                    }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(homeVM.sound?.name ?? "")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.titleColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
            
                HStack(spacing: 5) {
//                    ClockDisplayView(
//                        time: Int(homeVM.audioPlayer.currentItem?.duration.seconds ?? 0 - homeVM.audioPlayer.currentTime().seconds),
//                        font: .caption)
                    ClockDisplayView(time: homeVM.duration - Int(homeVM.currentTime), font: .caption2)
                    Text("left")
                }
            }
            .font(.caption2)
            .gesture(
                DragGesture()
                    .onEnded { drag in
                        homeVM.isViewingSongPlayer = true
                    }
            )

            Spacer()

            HStack(spacing: 25) {
                // Play button
                Button {
                    if homeVM.isPlaying {
                        homeVM.stopPlayer()
                    } else {
                        homeVM.startPlayer()
                    }
                   
                } label: {
                    if let player = homeVM.audioPlayer {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .frame(width: buttonSize, height: buttonSize, alignment: .center)
                    } else {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .frame(width: buttonSize, height: buttonSize, alignment: .center)
                    }
                }
                if homeVM.portfolioSounds.count > 1 {
                    Button {
                        homeVM.skipToNextSound()
                    } label: {
                        Image(systemName: "forward.end")
                            .resizable()
                            .frame(width: buttonSize - 5, height: buttonSize - 5, alignment: .center)
                    }
                }
            }
            .foregroundColor(Color.theme.customBlue)
            .padding(.trailing)
            
        }
        .onTapGesture {
            homeVM.isViewingSongPlayer = true
        }

        .frame(width: UIScreen.main.bounds.width, height: 80)
        .background(Color.theme.backgroundColor.opacity(0.9))
    }

}
//
struct PlayingNowBar_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayingNowBar()
            .preferredColorScheme(.light)
            .environmentObject(dev.homeVM)
            .previewLayout(.sizeThatFits)
        
        PlayingNowBar()
            .preferredColorScheme(.dark)
            .environmentObject(dev.homeVM)
            .previewLayout(.sizeThatFits)
    }
}
