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
                    .scaledToFill()
                    
                
            } else  {
                ZStack {
                    ProgressView()
                    Rectangle()
                        
                        .foregroundColor(.gray)
                        .opacity(0.2)
                }
                .frame(width: 117, height: 100)
            }
               
//            } else {
//                ZStack {
//                    Image(systemName: "questionmark")
//                     Rectangle()
//                         .frame(width: 117, height: 100)
//                         .foregroundColor(.gray)
//                         .opacity(0.2)
//                }
//
//
//            }
        }
    }
}



struct SoundImageView_Previews: PreviewProvider {
    static var previews: some View {
        SoundImageView(sound: SoundsModel())
    }
}
