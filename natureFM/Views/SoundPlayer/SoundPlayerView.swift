import SwiftUI
import AVKit

struct SoundPlayerView: View {
    @ObservedObject var playerVM: PlayerViewModel
    @ObservedObject var libraryVM: LibraryViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var tabSelection: Int

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                // Image
                if let sound = playerVM.sound {
                    SoundImageView(sound: sound)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.75, maxHeight: UIScreen.main.bounds.height * 0.35)
                        .cornerRadius(15)
                        .shadow(color: Color.theme.backgroundColor, radius: 2)
                    
                    // Sound title header
                    VStack {
                        Text(sound.name)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.theme.titleColor)
                        HStack {
                            Text(sound.categoryName)
                            Text("|")
                            Text(sound.locationName)
                        }
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.theme.titleColor)
                    }
                }
                
                
                
                // Playing next component
                VStack(alignment: .leading) {
                    // Playing next header
                    HStack(spacing: 5) {
                        Image(systemName: "arrow.down")
                        Text("library")
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
                    
                    List {
                        if libraryVM.mySounds.count > 0 {
                            ForEach(libraryVM.mySounds.filter({ $0 != playerVM.sound }), id: \.id) { sound in
                                Text(sound.name)
                            }
                            .listRowSeparator(.hidden)
                           
                        } else {
                            Button("Download songs for your library") {
                                // Send user to library
                                tabSelection = 1
                                playerVM.isViewingSongPlayer = false
                            }
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
                ProgressBarView(
                    stopPlayer: { print("Stop player") },
                    startPlayer: { print("Start player") },
                    currentTime: $playerVM.currentTime,
                    duration: playerVM.duration
                )
     
                AudioControlButtonsView(
                    playerVM: playerVM,
                    libraryVM: libraryVM
                )
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
//                            presentationMode.wrappedValue.dismiss()
                            playerVM.isViewingSongPlayerTab = true
                            playerVM.isViewingSongPlayer = false
                        } label: {
                            Image(systemName: "chevron.down.circle.fill")
                        }
                        .foregroundColor(Color.theme.customBlue)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            }
        }
    }
    
struct SoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerView(
            playerVM: dev.playerVM,
            libraryVM: LibraryViewModel(),
//            libraryVM: dev.libraryVM,
            tabSelection: .constant(1)
        )
    }
}

