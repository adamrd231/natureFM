//
//  FeaturedImageLayoutView.swift
//  natureFM
//
//  Created by Adam Reed on 2/14/22.
//

import SwiftUI

struct FeaturedImageLayoutView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State var sound: SoundsModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Featured Sound")
                .foregroundColor(Color.theme.titleColor)
                .font(.title2)
                .fontWeight(.bold)
            VStack(alignment: .leading) {
                      
                SoundImageView(sound: sound)
        
                HStack {
                    VStack(alignment: .leading) {
                        Text(sound.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(sound.locationName)
                            .font(.caption)
                        Text(sound.categoryName)
                            .font(.caption)
                        Text(sound.freeSong ? "Free" : "Subscription")
                            .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue )
                            .font(.caption)
                    }
                    Spacer()
                    Button(action: {
                        vm.downloadedContentService.saveSound(sound: sound)
                    }) {
                        Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }.foregroundColor(Color.theme.titleColor)
                }
            }
        }
    }
}

struct FeaturedImageLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedImageLayoutView(sound: SoundsModel())
    }
}
