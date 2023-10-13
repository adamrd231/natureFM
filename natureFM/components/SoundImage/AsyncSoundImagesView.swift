//
//  AsyncSoundImagesView.swift
//  natureFM
//
//  Created by Adam Reed on 10/13/23.
//

import SwiftUI

struct AsyncSoundImagesView: View {
    let url: String
    @StateObject var vm: AsyncSoundImageViewModel

    init(url: String) {
        self.url = url
        _vm = StateObject(wrappedValue: AsyncSoundImageViewModel(url: url))
    }

    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .contentShape(Rectangle())
            } else  {
                ZStack {
                    ProgressView()
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.2)
                }
                .frame(width: 117, height: 100)
            }
        }
    }
}

struct AsyncSoundImagesView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncSoundImagesView(url: "Test")
    }
}
