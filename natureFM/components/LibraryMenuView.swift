import SwiftUI

struct LibraryMenuView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State var sound: SoundsModel
    
    var body: some View {
        Menu(content: {
            HStack {
                Button(action: {
                    vm.downloadedContentService.deleteSound(sound: sound)
                }) {
                    Text("Delete from Library").foregroundColor(.red)
                    Spacer()
                    Image(systemName: "trash").foregroundColor(.red)
                }
                
            }
//            HStack {
//                Button(action: {
//
//                }) {
//
//                    Text("Add to a playlist...")
//                    Spacer()
//                    Image(systemName: "music.note.list")
//                }
//            }
            
            
        }, label: {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.theme.customBlue)

        })
    }
}

struct LibraryMenuView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryMenuView(sound: SoundsModel())
    }
}
