//
//  PlayingNowBar.swift
//  natureFM
//
//  Created by Adam Reed on 10/1/23.
//

import SwiftUI

struct PlayingNowBar: View {
    
    let buttonSize: CGFloat = 25
    let title: String
    
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .frame(width: 50, height: 50, alignment: .center)
                .padding(.leading)
            Text(title)
                .bold()
                .foregroundColor(Color.theme.titleColor)
            Spacer()
            HStack(spacing: 30) {
                Image(systemName: "pause.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
                Image(systemName: "play.fill")
                    .resizable()
                    .frame(width: buttonSize, height: buttonSize, alignment: .center)
            }
            .padding(.trailing)
           
                
        }
        .frame(width: UIScreen.main.bounds.width, height: 75)
        .background(Color.theme.backgroundColor.opacity(0.9))
    }
}

struct PlayingNowBar_Previews: PreviewProvider {
    static var previews: some View {
        PlayingNowBar(title: "Testing a title")
    }
}
