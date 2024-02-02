import SwiftUI

struct PlayingNowBar: View {
    @ObservedObject var libraryVM: LibraryViewModel
    
    let buttonSize: CGFloat = 25
    
    var body: some View {
        HStack(spacing: 0) {
            if let sound = libraryVM.sound {
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
                            time: Int(Double(libraryVM.duration) - libraryVM.currentTime),
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
                    libraryVM.isViewingSongPlayer = true
                    libraryVM.isViewingSongPlayerTab = false
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }
                
                // Play button
                Button {
                    if libraryVM.isPlaying {
                        libraryVM.stopPlayer()
                    } else {
                        libraryVM.startPlayer()
                    }
                   
                } label: {
                    if let player = libraryVM.audioPlayer {
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
            libraryVM: dev.libraryVM
        )
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
}
