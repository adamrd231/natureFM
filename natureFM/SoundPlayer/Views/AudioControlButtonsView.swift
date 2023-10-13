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
    private let buttonAdjustment: CGFloat = 10
    
    var body: some View {
        HStack(spacing: 25) {
            Button {
                
            } label: {
                Image(systemName: "backward.end")
                    .resizable()
                    .frame(width: buttonSize - buttonAdjustment, height: buttonSize - buttonAdjustment)
            }
            Spacer()
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
                Image(systemName: homeVM.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: buttonSize + buttonAdjustment, height: buttonSize + buttonAdjustment)
            }
            Button {
                homeVM.skipForward15()
            } label: {
                Image(systemName: "goforward.15")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "forward.end")
                    .resizable()
                    .frame(width: buttonSize - buttonAdjustment, height: buttonSize - buttonAdjustment)
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
