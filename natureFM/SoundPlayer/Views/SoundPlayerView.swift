import SwiftUI
import AVKit

struct SoundPlayerView: View {
    
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    private let buttonSize: CGFloat = 30
    
    var body: some View {
        VStack {
            if let imageLink = soundVM.sound?.imageFileLink {
                AsyncImage(
                    url: URL(string: imageLink),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .contentShape(Rectangle())
                            
                    }) {
                        ProgressView()
                    }
            } else {
                Rectangle()
                    .foregroundColor(Color.theme.backgroundColor)
            }
           
            Text(soundVM.sound?.name ?? "N/A")
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.theme.backgroundColor)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                Rectangle()
                    .foregroundColor(Color.theme.customBlue)
                    .frame(width: (UIScreen.main.bounds.width * soundVM.percentagePlayed))
            
            }
            .frame(height: 5)
            .cornerRadius(5)
            .padding(.horizontal)
            
            
            HStack(spacing: 25) {
                Image(systemName: "gobackward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
                Button {
                    soundVM.audioIsPlaying.toggle()
                } label: {
                    Image(systemName: soundVM.audioIsPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
               
                Image(systemName: "goforward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
            .padding()
        }
    }
    
    struct SoundPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            SoundPlayerView()
                .environmentObject(dev.soundVM)
        }
    }
}
