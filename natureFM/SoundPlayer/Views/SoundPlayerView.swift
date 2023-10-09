import SwiftUI
import AVKit

struct SoundPlayerView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    private let buttonSize: CGFloat = 30
    
    var body: some View {
        VStack {
            if let imageLink = vm.sound?.imageFileLink {
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
           
            Text(vm.sound?.name ?? "N/A")
            
            VStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.theme.backgroundColor)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                    Rectangle()
                        .foregroundColor(Color.theme.customBlue)
                        .frame(width: ((UIScreen.main.bounds.width * 0.9) * vm.percentagePlayed))
                
                }
                .frame(height: 5)
                .cornerRadius(5)
                .padding(.horizontal)
                HStack {
                    ClockDisplayView(time: Int(vm.audioPlayer.currentTime), font: .caption)
                    Spacer()
                    ClockDisplayView(time: Int(vm.audioPlayer.duration), font: .caption)
                }
                .padding(.horizontal)
                .font(.caption)
            }
          
            HStack(spacing: 25) {
                Button {
                    vm.skipBackward15()
                } label: {
                    Image(systemName: "gobackward.15")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
               
                Button {
                    vm.audioPlayer.isPlaying ? vm.stopPlayer() : vm.startPlayer()
                } label: {
                    Image(systemName: vm.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
                Button {
                    vm.skipForward15()
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
