//
//  ProgressBarView.swift
//  natureFM
//
//  Created by Adam Reed on 10/12/23.
//

import SwiftUI

struct ProgressBarView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @State var wasPlaying: Bool = false
    @State var isDragging: Bool = false
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { isChanging in
                if let player = homeVM.audioPlayer {
                    if player.isPlaying {
                        homeVM.stopPlayer()
                        wasPlaying = true
                    }
                    
                }
            }
            .onEnded { isDragging in
                if let player = homeVM.audioPlayer {
                    let percentageToGoTo = isDragging.location.x / UIScreen.main.bounds.width * 0.9
                    player.currentTime = percentageToGoTo * player.duration
                    if wasPlaying {
                        homeVM.startPlayer()
                        wasPlaying = false
                    }
                }
            }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.theme.backgroundColor)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                Rectangle()
                    .foregroundColor(Color.theme.customBlue)
                    .frame(width: ((UIScreen.main.bounds.width * 0.9) * homeVM.percentagePlayed))
                   
            }
            .frame(height: 5)
            .cornerRadius(5)
            .padding(.horizontal)
            .overlay(alignment: .leading) {
                Circle()
                    .foregroundColor(Color.theme.customBlue)
                    .frame(width: 10, height: 10)
                    .offset(x: (UIScreen.main.bounds.width * 0.9) * homeVM.percentagePlayed + 10)
                    .gesture(drag)
            }
            
            HStack {
                ClockDisplayView(time: Int(homeVM.currentTime), font: .caption)
                Spacer()
                ClockDisplayView(time: Int((homeVM.audioPlayer?.duration ?? 1) - 1), font: .caption)
            }
            .padding(.horizontal)
            .font(.caption)
        }
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView()
    }
}
