//
//  HorizontalScrollView.swift
//  natureFM
//
//  Created by Adam Reed on 2/8/22.
//

import SwiftUI

struct HorizontalScrollView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    
    var soundArray: [SoundsModel]

    var body: some View {
        HStack(spacing: 50) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(soundArray) { sound in
                        VStack(alignment: .leading, spacing: 10) {
                            SoundImageView(sound: sound)
                                .frame(width: 200, height: 150)
                                .clipped()
                               
                            HStack {
        
                                Button(action: {
                                    vm.downloadedContentService.saveSound(sound: sound)
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }.foregroundColor(Color.theme.titleColor)
                                
                                VStack(alignment: .leading) {
                                    Text(sound.name).font(.subheadline)
                                    Text(sound.freeSong ? "Free" : "Subscription")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 5)
                                        .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue)
                                        
                                   
                                }
                                Spacer()
                            }
                        }.padding(.trailing, 3)
                    }
                }
            }
        }
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(soundArray: [SoundsModel(), SoundsModel()])
    }
}
