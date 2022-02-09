//
//  HorizontalScrollView.swift
//  natureFM
//
//  Created by Adam Reed on 2/8/22.
//

import SwiftUI

struct HorizontalScrollView: View {
    
    @EnvironmentObject var vm: HomeViewModel

    
    var body: some View {
        HStack(spacing: 5) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(vm.allSounds) { sound in
                        VStack(alignment: .leading, spacing: 5) {
                            SoundImageView(sound: sound)
                                .frame(width: 250)
                            HStack {
                                Button(action: {
                                    vm.downloadedContentService.saveSound(sound: sound)
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(sound.name).font(.subheadline)
                                    HStack {
                                        Text(sound.categoryName).font(.caption2)
                                        Text(sound.locationName).font(.caption2)
                                    }
                                    Text(sound.freeSong ? "Free" : "Subscription")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                   
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView()
    }
}
