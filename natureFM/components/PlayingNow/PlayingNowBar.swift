//
//  PlayingNowBar.swift
//  natureFM
//
//  Created by Adam Reed on 10/1/23.
//

import SwiftUI

struct PlayingNowBar: View {
    
    let buttonSize: CGFloat = 25
    let title: String
    let sound: SoundsModel
    
    
    var body: some View {
        HStack(spacing: 10) {
            SoundImageView(sound: sound)
                .frame(width: 50, height: 50, alignment: .center)
                .padding(.leading)
            Text(title)
                .bold()
                .foregroundColor(Color.theme.titleColor)
            Spacer()
            HStack(spacing: 30) {
                Button {
                    print("Pause button")
                } label: {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }
                Button {
                    print("play button")
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: buttonSize, height: buttonSize, alignment: .center)
                }
            }
            .padding(.trailing)
           
                
        }
        .onTapGesture {
            print("Teehee")
        }
        .frame(width: UIScreen.main.bounds.width, height: 75)
        .background(Color.theme.backgroundColor.opacity(0.9))
    }
}

struct PlayingNowBar_Previews: PreviewProvider {
    static var previews: some View {
        PlayingNowBar(title: "Testing a title", sound: SoundsModel())
    }
}
