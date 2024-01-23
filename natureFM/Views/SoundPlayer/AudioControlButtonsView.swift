import SwiftUI

struct AudioControlButtonsView: View {
    @ObservedObject var playerVM: PlayerViewModel
    @ObservedObject var libraryVM: LibraryViewModel

    private let buttonSize: CGFloat = 30
    private let buttonAdjustment: CGFloat = 10
    
    var body: some View {
        HStack(spacing: 25) {
            Button {
                // Skip backward a song
                playerVM.skipSongBackwards()
               
            } label: {
                Image(systemName: "backward.end")
                    .resizable()
                    .frame(width: buttonSize - buttonAdjustment, height: buttonSize - buttonAdjustment)
            }
            Spacer()
            Button {
                // Skip backward 15 sec
                playerVM.skipBackward15()
            } label: {
                Image(systemName: "gobackward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
           
            Button {
                if playerVM.isPlaying {
                   // stop player
                    playerVM.stopPlayer()
                } else {
                   // start player
                    playerVM.startPlayer()
                }
               
            } label: {
                Image(systemName: playerVM.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: buttonSize + buttonAdjustment, height: buttonSize + buttonAdjustment)
            }
            Button {
                // Skip forward 15
                playerVM.skipForward15()
            } label: {
                Image(systemName: "goforward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
            Spacer()
            Button {
                // skip to next song
                playerVM.skipSongForward()
            } label: {
                Image(systemName: "forward.end")
                    .resizable()
                    .frame(width: buttonSize - buttonAdjustment, height: buttonSize - buttonAdjustment)
            }
        }
        .foregroundColor(Color.theme.customBlue)
        .padding()
    }
}

struct AudioControlButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        AudioControlButtonsView(
            playerVM: dev.playerVM,
            libraryVM: dev.libraryVM
        )
    }
}
