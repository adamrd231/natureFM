import SwiftUI
import AVKit

struct SoundPlayerView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    private let buttonSize: CGFloat = 30
    
    var body: some View {
        VStack {
            if let imageLink = homeVM.sound?.imageFileLink {
                AsyncImage(
                    url: URL(string: imageLink),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .contentShape(Rectangle())
                            
                    }) {
                        ProgressView()
                    }
            } else {
                Rectangle()
                    .foregroundColor(Color.theme.backgroundColor)
            }
           
            Text(homeVM.sound?.name ?? "N/A")
            
            VStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.theme.backgroundColor)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                    Rectangle()
                        .foregroundColor(Color.theme.customBlue)
                        .frame(width: ((UIScreen.main.bounds.width * 0.9) * homeVM.percentagePlayed))
                    Circle()
                        .foregroundColor(Color.theme.customBlue)
                        .offset(x: homeVM.percentagePlayed)
                }
                .frame(height: 5)
                .cornerRadius(5)
                .padding(.horizontal)
                HStack {
                    ClockDisplayView(time: Int(homeVM.audioPlayer.currentTime().seconds), font: .caption)
                    Spacer()
                    ClockDisplayView(time: Int(homeVM.audioPlayer.currentItem?.asset.duration.seconds ?? 0), font: .caption)
                
                }
                .padding(.horizontal)
                .font(.caption)
            }
          
            HStack(spacing: 25) {
                Button {
//                    homeVM.skipBackward15()
                } label: {
                    Image(systemName: "gobackward.15")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
               
                Button {
                    homeVM.startPlayer()
                } label: {
                    Image(systemName: homeVM.audioPlayer.timeControlStatus == .playing ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
                Button {
//                    homeVM.skipForward15()
                } label: {
                    Image(systemName: "goforward.15")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
            }
            .padding()
        }
    }
    
    struct SoundPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            SoundPlayerView()
                .environmentObject(dev.homeVM)
        }
    }
}
