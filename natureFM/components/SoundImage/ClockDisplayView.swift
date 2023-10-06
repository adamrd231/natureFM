//
//  ClockDisplayView.swift
//  natureFM
//
//  Created by Adam Reed on 10/6/23.
//

import SwiftUI

struct ClockDisplayView: View {
    let time: Int
    let font: Font

    var body: some View {
        HStack(spacing: .zero) {
            if time / 60 > 9 {
                Text(time / 60, format: .number)
            } else {
                Text("0")
                Text(time / 60, format: .number)
            }
            Text(":")
            if time % 60 > 10 {
                Text(time % 60, format: .number)
            } else {
                Text("0")
                Text(time % 60, format: .number)
            }
        }
        .font(font)
    }
}

struct ClockDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ClockDisplayView(time: 565, font: .caption)
    }
}
