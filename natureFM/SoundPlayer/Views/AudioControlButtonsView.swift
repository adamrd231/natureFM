//
//  AudioControlButtonsView.swift
//  natureFM
//
//  Created by Adam Reed on 10/12/23.
//

import SwiftUI

struct AudioControlButtonsView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    private let buttonSize: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 25) {
            Button {
                homeVM.skipBackward15()
            } label: {
                Image(systemName: "gobackward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
           
            Button {
                if homeVM.isPlaying {
                    homeVM.stopPlayer()
                } else {
                    homeVM.startPlayer()
                }
               
            } label: {
                Image(systemName: homeVM.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
            Button {
                homeVM.skipForward15()
            } label: {
                Image(systemName: "goforward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
        }
        .padding()
    }
}

struct AudioControlButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        AudioControlButtonsView()
    }
}
