//
//  PlayingNowBar.swift
//  natureFM
//
//  Created by Adam Reed on 10/1/23.
//

import SwiftUI

struct PlayingNowBar: View {
    
    let buttonSize: CGFloat = 25
    let sound: SoundsModel
    @StateObject var soundVM: SoundPlayerViewModel
    @Binding var isViewingSongPlayer: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            SoundImageView(sound: sound)
                .frame(width: 66, height: 50, alignment: .center)
                .clipped()
            Text(sound.name)
                .bold()
                .foregroundColor(Color.theme.titleColor)
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
        .onTapGesture {
            print("Teehee")
            isViewingSongPlayer.toggle()
        }
        .frame(width: UIScreen.main.bounds.width, height: 75)
        .background(Color.theme.backgroundColor.opacity(0.9))
    }
}

struct PlayingNowBar_Previews: PreviewProvider {
    static var previews: some View {
        PlayingNowBar(
            sound: SoundsModel(),
            soundVM: SoundPlayerViewModel(sound: SoundsModel()),
            isViewingSongPlayer: .constant(false)
        )
    }
}
