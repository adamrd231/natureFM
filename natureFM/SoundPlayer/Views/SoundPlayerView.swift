import SwiftUI
import AVKit

struct SoundPlayerView: View {
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        VStack {
            if let sound = homeVM.sound {
                SoundImageView(sound: sound)
            }
           
            Text(homeVM.sound?.name ?? "N/A")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.titleColor)
            
            ProgressBarView()
                .environmentObject(homeVM)
          
            AudioControlButtonsView()
                .environmentObject(homeVM)
        }
    }
    
    struct SoundPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            SoundPlayerView()
                .environmentObject(dev.homeVM)
        }
    }
}
