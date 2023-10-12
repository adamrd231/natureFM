import SwiftUI

struct SoundImageView: View {
    let sound: SoundsModel
    @StateObject var vm: SoundImageViewModel

    
    init(sound: SoundsModel) {

        self.sound = sound
        _vm = StateObject(wrappedValue: SoundImageViewModel(sound: sound))
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



struct SoundImageView_Previews: PreviewProvider {
    static var previews: some View {
        SoundImageView(sound: dev.testSound)
    }
}
