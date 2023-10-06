import SwiftUI
import AVKit

struct SoundPlayerView: View {
    
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    
    var body: some View {
        Text(soundVM.sound?.name ?? "N/A")
    }
    
    struct SoundPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            SoundPlayerView()
                .environmentObject(dev.soundVM)
        }
    }
}
