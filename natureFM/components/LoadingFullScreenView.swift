//
//  LoadingFullScreenView.swift
//  natureFM
//
//  Created by Adam Reed on 2/2/24.
//

import SwiftUI

struct LoadingFullScreenView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.theme.backgroundColor.opacity(0.33))
            VStack {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color.theme.customBlue)
                Text("Loading")
                    .fontWeight(.bold)
                    
            }
            .padding()
            .background(Color.theme.backgroundColor.opacity(0.66))
            .cornerRadius(15)
        }
        .foregroundColor(Color.theme.customBlue)
    }
}

struct LoadingFullScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingFullScreenView()
    }
}
