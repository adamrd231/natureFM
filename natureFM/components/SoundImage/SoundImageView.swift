//
//  SoundImageView.swift
//  natureFM
//
//  Created by Adam Reed on 2/7/22.
//

import SwiftUI

struct SoundImageView: View {
    
    @StateObject var vm: SoundImageViewModel
    
    init(sound: SoundsModel) {
        _vm = StateObject(wrappedValue: SoundImageViewModel(sound: sound))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            } else if vm.isLoading {
               ProgressView()
            } else {
                Image(systemName: "questionmark")
                   
            }
        }
    }
}



struct SoundImageView_Previews: PreviewProvider {
    static var previews: some View {
        SoundImageView(sound: SoundsModel())
    }
}
