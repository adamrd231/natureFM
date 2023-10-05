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
            
            VStack(alignment: .leading) {
                VStack(spacing: 3) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.lightGray))
                        .cornerRadius(5)
                        .opacity(0.8)
                        .gesture(
                            DragGesture()
                                .onEnded {drag in
                                    print("done dragging")
                                    // TODO: Show player if user drags up here.
                                }
                        )
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.lightGray))
                        .cornerRadius(5)
                        .opacity(0.5)
                        .gesture(
                            DragGesture()
                                .onEnded {drag in
                                    print("done dragging")
                                    // TODO: Show player if user drags up here.
                                }
                        )
                }
            
                Text(soundVM.sound?.name ?? "")
                    .font(.callout)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.theme.titleColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(soundVM.sound?.categoryName ?? "")
                    .font(.caption)
                    .fontWeight(.medium)
         
            }
           

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
