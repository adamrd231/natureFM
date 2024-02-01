//
//  CatalogSoundView.swift
//  natureFM
//
//  Created by Adam Reed on 2/1/24.
//

import SwiftUI

struct CatalogSoundView: View {
    let sound: SoundsModel
    
    var body: some View {
        HStack {
            SoundImageView(sound: sound)
                .frame(width: 100, height: 66)
                .clipped()
            SoundDetailStackView(sound: sound)
            
            Spacer()
            Image(systemName: "menucard")
                .padding()
        }
    }
}

struct CatalogSoundView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogSoundView(
            sound: dev.testSound
        )
    }
}
