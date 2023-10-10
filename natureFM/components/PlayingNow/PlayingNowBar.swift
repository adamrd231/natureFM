//
//  PlayingNowBar.swift
//  natureFM
//
//  Created by Adam Reed on 10/1/23.
//

import SwiftUI

struct PlayingNowBar: View {
    @EnvironmentObject var homeVM: HomeViewModel
    let buttonSize: CGFloat = 25
    
    var body: some View {
        HStack(spacing: 15) {

            AsyncImage(
                url: URL(string: homeVM.sound?.imageFileLink ?? ""),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .contentShape(Rectangle())
                        .frame(height: 80)
                        .frame(maxWidth: 90)
                        .clipped()

            }) {
                ZStack {
                    Rectangle()
                         .frame(height: 80)
                         .frame(maxWidth: 90)
                         .foregroundColor(Color.theme.titleColor)
                    ProgressView()
                        .tint(Color.theme.backgroundColor)
                  
                }
             
            }
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
           
            
            VStack(alignment: .leading, spacing: 2) {

                Text(homeVM.sound?.name ?? "")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.titleColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
            
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
                if homeVM.audioPlayer.timeControlStatus == .playing {
                    homeVM.stopPlayer()
                } else {
                    homeVM.startPlayer()
                }
               
            } label: {
                Image(systemName: homeVM.audioPlayer.timeControlStatus == .playing ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
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
