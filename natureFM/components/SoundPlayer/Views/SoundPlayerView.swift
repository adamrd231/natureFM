import SwiftUI
import AVKit

struct SoundPlayerView: View {
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        VStack(spacing: 25) {
            // Image
            if let sound = homeVM.sound {
                SoundImageView(sound: sound)
            }
            
            // Sound title header
            VStack {
                Text(homeVM.sound?.name ?? "N/A")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.titleColor)
                HStack {
                    Text(homeVM.sound?.categoryName ?? "n/a")
                    Text("|")
                    Text(homeVM.sound?.locationName ?? "n/a")
                }
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.titleColor)
            }
           
            // Playing next component
            VStack(alignment: .leading, spacing: 15) {
                // Playing next header
                HStack {
                    Image(systemName: "arrow.down")
                        .foregroundColor(Color.theme.titleColor.opacity(0.6))
                    Text(homeVM.isRepeating ? "playing next" : "library")
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.titleColor.opacity(0.6))
                    Spacer()
                    HStack {
                        Button {
                            homeVM.isRepeating.toggle()
                        } label: {
                            Image(systemName: homeVM.isRepeating ? "repeat.circle.fill" : "repeat")
                        }
                        Button {
                            homeVM.isShuffling.toggle()
                        } label: {
                            Image(systemName: homeVM.isShuffling ? "shuffle.circle.fill" : "shuffle")
                        }
                    }
                    .foregroundColor(Color.theme.customBlue)
                }
                
                // List of current songs available to play
                if homeVM.portfolioSounds.count > 0 {
                    List {
                        ForEach(homeVM.portfolioSounds, id: \.id) { sound in
                            HStack(spacing: 10) {
                                SoundImageView(sound: sound)
                                    .frame(width: 30, height: 30)
                                    .clipped()
                                Text(sound.name)
                                Spacer()
                            }
                            .foregroundColor(Color.theme.titleColor.opacity(0.9))
                            .onTapGesture {
                                homeVM.stopPlayer()
                                homeVM.sound = sound
                            }
                        }
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
            
            AudioControlButtonsView()
                .environmentObject(homeVM)
            ProgressBarView()
              .environmentObject(homeVM)
              .padding(.bottom)

            }
        }
    }
    
struct SoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerView()
            .environmentObject(dev.homeVM)
    }
}

