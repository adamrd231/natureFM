//
//  AudioControlButtonsView.swift
//  natureFM
//
//  Created by Adam Reed on 10/12/23.
//

import SwiftUI

struct AudioControlButtonsView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    let isPlaying: Bool
    private let buttonSize: CGFloat = 30
    private let buttonAdjustment: CGFloat = 10
    
    var body: some View {
        HStack(spacing: 25) {
            Button {
                // Skip to next song
            } label: {
                Image(systemName: "backward.end")
                    .resizable()
                    .frame(width: buttonSize - buttonAdjustment, height: buttonSize - buttonAdjustment)
            }
            Spacer()
            Button {
                // Skip backward 15 sec
            } label: {
                Image(systemName: "gobackward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
           
            Button {
                if isPlaying {
                   // stop player
                } else {
                   // start player
                }
               
            } label: {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: buttonSize + buttonAdjustment, height: buttonSize + buttonAdjustment)
            }
            Button {
                // Skip forward 15
            } label: {
                Image(systemName: "goforward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
            Spacer()
            Button {
                // skip to next song
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
            isPlaying: false
        )
    }
}
