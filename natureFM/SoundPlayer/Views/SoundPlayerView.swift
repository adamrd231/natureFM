import SwiftUI
import AVKit

struct SoundPlayerView: View {
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        VStack(spacing: 25) {
            if let sound = homeVM.sound {
                SoundImageView(sound: sound)
            }
           
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
            
            VStack {
                if homeVM.portfolioSounds.count > 0 {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Up next")
                                .fontWeight(.medium)
                            Spacer()
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
                        .padding(.horizontal)
                        
                        List {
                            ForEach(homeVM.portfolioSounds, id: \.id) { sound in
                                HStack(spacing: 10) {
                                    SoundImageView(sound: sound)
                                        .frame(width: 30, height: 30)
                                        .clipped()
                                    Text(sound.name)
                                    Spacer()
                                }
                                .onTapGesture {
                                    homeVM.stopPlayer()
                                    homeVM.sound = sound
                                }
                            }
                        }
                        .listStyle(.plain)
                        
                    }
                    
                    
                    AudioControlButtonsView()
                        .environmentObject(homeVM)
                    ProgressBarView()
                      .environmentObject(homeVM)
                      .padding(.bottom)
                }
            }
        }
    }
    
    struct SoundPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            SoundPlayerView()
                .environmentObject(dev.homeVM)
        }
    }
}
