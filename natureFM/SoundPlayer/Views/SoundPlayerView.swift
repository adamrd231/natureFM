import SwiftUI
import AVKit

struct SoundPlayerView: View {
    
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    private let buttonSize: CGFloat = 30
    
    var body: some View {
        VStack {
            if let imageLink = soundVM.sound?.imageFileLink {
                AsyncImage(
                    url: URL(string: imageLink),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                            .contentShape(Rectangle())
                            
                    }) {
                        ProgressView()
                    }
            } else {
                Rectangle()
                    .foregroundColor(Color.theme.backgroundColor)
            }
           
            Text(soundVM.sound?.name ?? "N/A")
            
            ZStack(alignment: .center) {
                Rectangle()
                    .frame(height: 5)
                    
                    .foregroundColor(Color.blue)
                Rectangle()
                    .trim(from: 0, to: 0.5)
                    .frame(height: 5)
                    
                    .foregroundColor(Color.red)
      
         
                    
            }
            .padding(.horizontal)
            
            
            HStack(spacing: 25) {
                Image(systemName: "gobackward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
                Image(systemName: "goforward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
            .padding()
            
           
            
        }
    }
    
    struct SoundPlayerView_Previews: PreviewProvider {
        static var previews: some View {
            SoundPlayerView()
                .environmentObject(dev.soundVM)
        }
    }
}
