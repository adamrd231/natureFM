import SwiftUI
import AVKit

struct SoundPlayerView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    private let buttonSize: CGFloat = 30
    @State var wasPlaying: Bool = false
    @State var isDragging: Bool = false
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { isChanging in
                if let player = homeVM.audioPlayer {
                    if player.isPlaying {
                        homeVM.stopPlayer()
                        wasPlaying = true
                    }
                    
                }
            }
            .onEnded { isDragging in
                if let player = homeVM.audioPlayer {
                    let percentageToGoTo = isDragging.location.x / UIScreen.main.bounds.width * 0.9
                    player.currentTime = percentageToGoTo * player.duration
                    if wasPlaying {
                        homeVM.startPlayer()
                        wasPlaying = false
                    }
                }
            }
    }
    
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
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.titleColor)
            
            VStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.theme.backgroundColor)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                    Rectangle()
                        .foregroundColor(Color.theme.customBlue)
                        .frame(width: ((UIScreen.main.bounds.width * 0.9) * homeVM.percentagePlayed))
                        .gesture(drag)
                }
                .frame(height: 5)
                .cornerRadius(5)
                .padding(.horizontal)
                .overlay(alignment: .leading) {
                    Circle()
                        .foregroundColor(Color.theme.customBlue)
                        .frame(width: 10, height: 10)
                        .offset(x: (UIScreen.main.bounds.width * 0.9) * homeVM.percentagePlayed + 10)
                }
                
                HStack {
                    ClockDisplayView(time: Int(homeVM.currentTime), font: .caption)
                    Spacer()
                    ClockDisplayView(time: Int(homeVM.audioPlayer?.duration ?? 0), font: .caption)
                }
                .padding(.horizontal)
                .font(.caption)
            }
          
            HStack(spacing: 25) {
                Button {
                    homeVM.skipBackward15()
                } label: {
                    Image(systemName: "gobackward.15")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
               
                Button {
                    if homeVM.isPlaying {
                        homeVM.stopPlayer()
                    } else {
                        homeVM.startPlayer()
                    }
                   
                } label: {
                    Image(systemName: homeVM.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize)
                }
                Button {
                    homeVM.skipForward15()
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
