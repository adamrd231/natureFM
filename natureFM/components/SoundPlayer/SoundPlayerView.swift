import SwiftUI
import AVKit

struct SoundPlayerView: View {
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var playerVM: PlayerViewModel
    // sound
    // array of sounds for playlist
    // isRepeating
    var body: some View {
        VStack {
            // Image
            if let sound = playerVM.sound {
                SoundImageView(sound: sound)
                    .padding()
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.33)
            }
            
            // Sound title header
            VStack {
                Text(playerVM.sound?.name ?? "N/A")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.titleColor)
                HStack {
                    Text(playerVM.sound?.categoryName ?? "n/a")
                    Text("|")
                    Text(playerVM.sound?.locationName ?? "n/a")
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.titleColor)
            }
           
            // Playing next component
            VStack(alignment: .leading, spacing: 10) {
                // Playing next header
                HStack(spacing: 5) {
                    Image(systemName: "arrow.down")
                    Text(playerVM.isRepeating ? "playing next" : "library")
                    Spacer()
                    HStack {
                        Button {
                            playerVM.isRepeating.toggle()
                        } label: {
                            Image(systemName: playerVM.isRepeating ? "repeat.circle.fill" : "repeat")
                        }
                        Button {
                            playerVM.isShuffling.toggle()
                        } label: {
                            Image(systemName: playerVM.isShuffling ? "shuffle.circle.fill" : "shuffle")
                        }
                    }
                    .foregroundColor(Color.theme.customBlue)
                }
                .foregroundColor(Color.theme.titleColor.opacity(0.6))
                
                
                // List of current songs available to play
                if homeVM.portfolioSounds.count > 0 {
                    List {
                        Text("list")
                    }
                    .listStyle(.plain)
                
                } else {
                    Button("Download songs for your library") {
                      // Send user to library
                        homeVM.tabSelection = 1
                        homeVM.isViewingSongPlayer = false
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
            AudioControlButtonsView(isPlaying: playerVM.isPlaying)
                .environmentObject(homeVM)
            ProgressBarView(
                stopPlayer: { print("Stop player") },
                startPlayer: { print("Start player") },
                currentTime: $playerVM.currentTime,
                duration: playerVM.duration
            )
              .environmentObject(homeVM)
              .padding(.bottom)

            }
        }
    }
    
struct SoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerView(
            homeVM: dev.homeVM,
            playerVM: dev.playerVM
        )
    }
}

