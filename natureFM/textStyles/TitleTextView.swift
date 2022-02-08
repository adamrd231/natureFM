//
//  TitleTextView.swift
//  natureFM
//
//  Created by Adam Reed on 11/4/21.
//

import SwiftUI

struct TitleTextView: View {
    
    @State var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .font(.title2)
            .bold()
    }
}

