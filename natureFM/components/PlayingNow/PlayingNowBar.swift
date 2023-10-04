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
                        .clipped()
                        .contentShape(Rectangle())
                        .frame(maxWidth: 75)

            }) {
                ProgressView()
            }
            
            Text(soundVM.sound?.name ?? "")
                .bold()
                .foregroundColor(Color.theme.titleColor)
            Text(soundVM.sound?.categoryName ?? "")
            Spacer()
            HStack(spacing: 30) {
                // Play button
                Button {
                    soundVM.audioIsPlaying.toggle()
                } label: {
                    Image(systemName:soundVM.audioIsPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.theme.backgroundColor.opacity(0.9))
        .frame(width: UIScreen.main.bounds.width, height: 75)
    }

}
//
struct PlayingNowBar_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayingNowBar()
            .environmentObject(dev.soundVM)
    }
}
