import SwiftUI

struct PlayingNowBar: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @State var currentSound: SoundsModel?
    let buttonSize: CGFloat = 25
    
    var body: some View {
        HStack(spacing: 15) {
            if let sound = currentSound {
                // This image needs to update based on current sound selection...
                SoundImageView(sound: sound)
                    .frame(height: 80)
                    .frame(maxWidth: 90)
                    .clipped()
           
                    .onChange(of: homeVM.sound, perform: { newValue in
                        print("sound updating in soundImageView")
                        if let sound = homeVM.sound {
                            print("unwrapped")
                            currentSound = sound
                        }
                   
                    })
                    .overlay(alignment: .topLeading) {
                        Button {
                            homeVM.isViewingSongPlayerTab = false
                        } label: {
                            Image(systemName: "cross.circle.fill")
                                .rotationEffect(Angle(degrees: 45))
                                .foregroundColor(Color.theme.titleColor.opacity(0.8))
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding(7)
                        }
                    }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(homeVM.sound?.name ?? "")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.titleColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .onAppear(perform: {
                        if let sound = homeVM.sound {
                            print("on appear sound")
                            currentSound = sound
                        }
                    })
            
                HStack(spacing: 5) {
//                    ClockDisplayView(
//                        time: Int(homeVM.audioPlayer.currentItem?.duration.seconds ?? 0 - homeVM.audioPlayer.currentTime().seconds),
//                        font: .caption)
                    Text("left")
                   
                }
            }
            .font(.caption2)
            .gesture(
                DragGesture()
                    .onEnded { drag in
                        homeVM.isViewingSongPlayer = true
                    }
            )

            Spacer()

            // Play button
            Button {
                if homeVM.isPlaying {
                    homeVM.stopPlayer()
                } else {
                    homeVM.startPlayer()
                }
               
            } label: {
                if let player = homeVM.audioPlayer {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize, alignment: .center)
                } else {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }
            }
            .padding(.trailing)
        }
        .onTapGesture {
            homeVM.isViewingSongPlayer = true
        }

        .frame(width: UIScreen.main.bounds.width, height: 80)
        .background(Color.theme.backgroundColor.opacity(0.9))
    }

}
//
struct PlayingNowBar_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayingNowBar()
            .preferredColorScheme(.light)
            .environmentObject(dev.homeVM)
            .previewLayout(.sizeThatFits)
        
        PlayingNowBar()
            .preferredColorScheme(.dark)
            .environmentObject(dev.homeVM)
            .previewLayout(.sizeThatFits)
    }
}
