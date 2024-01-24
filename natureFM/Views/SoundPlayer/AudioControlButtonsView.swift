import SwiftUI

struct AudioControlButtonsView: View {
    @ObservedObject var libraryVM: LibraryViewModel

    private let buttonSize: CGFloat = 30
    private let buttonAdjustment: CGFloat = 10
    
    var body: some View {
        HStack(spacing: 25) {
            Button {
                // Skip backward a song
                libraryVM.skipSongBackwards()
               
            } label: {
                Image(systemName: "backward.end")
                    .resizable()
                    .frame(width: buttonSize - buttonAdjustment, height: buttonSize - buttonAdjustment)
            }
            Spacer()
            Button {
                // Skip backward 15 sec
                libraryVM.skipBackward15()
            } label: {
                Image(systemName: "gobackward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
           
            Button {
                if libraryVM.isPlaying {
                   // stop player
                    libraryVM.stopPlayer()
                } else {
                   // start player
                    libraryVM.startPlayer()
                }
               
            } label: {
                Image(systemName: libraryVM.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: buttonSize + buttonAdjustment, height: buttonSize + buttonAdjustment)
            }
            Button {
                // Skip forward 15
                libraryVM.skipForward15()
            } label: {
                Image(systemName: "goforward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
            Spacer()
            Button {
                // skip to next song
                libraryVM.skipSongForward()
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
            libraryVM: dev.libraryVM
        )
    }
}
