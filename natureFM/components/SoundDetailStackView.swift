//
//  SoundDetailStackView.swift
//  natureFM
//
//  Created by Adam Reed on 2/1/24.
//

import SwiftUI

struct SoundDetailStackView: View {
    let sound: SoundsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(sound.name)
                .font(.subheadline)
                .fontWeight(.bold)
            HStack {
                Text(sound.freeSong ? "Free content" : "Subscription")
                    .foregroundColor(Color.theme.backgroundColor)
                    .fontWeight(.bold)
                    .padding(5)
                    .background(sound.freeSong ? Color.theme.customBlue : Color.theme.customRed)
                Text("|")
                Text(sound.categoryName)
                   
            }
            .font(.footnote)
            
            HStack(spacing: 5) {
                Text("Length:")
                    .font(.footnote)
                Text(sound.duration.returnClockFormatAsString())
                    .font(.footnote)
            }
        }
        .foregroundColor(Color.theme.titleColor)
    }
}

struct SoundDetailStackView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailStackView(sound: dev.testSound)
    }
}
