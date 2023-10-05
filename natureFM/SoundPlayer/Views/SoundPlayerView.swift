import SwiftUI
import AVKit

struct SoundPlayerView: View {
    
    let sound: SoundsModel
    
    var body: some View {
        Text(sound.name)
    }
    
    struct SoundPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            SoundPlayerView(sound: dev.testSound)
        }
    }
}
