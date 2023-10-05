//
//  PlayingNowBar.swift
//  natureFM
//
//  Created by Adam Reed on 10/1/23.
//

import SwiftUI

struct PlayingNowBar: View {
    
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    let buttonSize: CGFloat = 25
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(
                url: URL(string: soundVM.sound?.imageFileLink ?? ""),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .contentShape(Rectangle())
                        .frame(height: 80)
                        .frame(maxWidth: 90)
                        .clipped()

            }) {
               Rectangle()
                    .frame(height: 80)
                    .frame(maxWidth: 90)
                    .foregroundColor(Color.theme.titleColor)
            }
            .background(.red)
            
            Text(soundVM.sound?.name ?? "")
                .font(.footnote)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.titleColor)

            Spacer()

            // Play button
            Button {
                soundVM.audioIsPlaying.toggle()
            } label: {
                Image(systemName:soundVM.audioIsPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
            }
            .padding(.trailing)
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
            .environmentObject(dev.soundVM)
            .previewLayout(.sizeThatFits)
        
        PlayingNowBar()
            .preferredColorScheme(.dark)
            .environmentObject(dev.soundVM)
            .previewLayout(.sizeThatFits)
    }
}
