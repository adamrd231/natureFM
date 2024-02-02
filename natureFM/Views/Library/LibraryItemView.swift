import SwiftUI

struct LibraryItemView: View {
    let sound: SoundsModel
    let selectSound: (SoundsModel) -> Void
    let removeFromLibrary: (SoundsModel) -> Void
    @Binding var isViewingTabPlayerView: Bool
    @Binding var isViewingFullPlayerView: Bool
    @State var isViewingMenu: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            SoundImageView(sound: sound)
                .frame(width: 66, height: 75)
                .cornerRadius(5)
                .clipped()
                .shadow(radius: 3)
            SoundDetailStackView(sound: sound)
            
            Spacer()
            Button {
                isViewingMenu.toggle()
            } label: {
                Image(systemName: "menucard")
                    .padding()
            }
            .foregroundColor(Color.theme.customBlue)
            .buttonStyle(.borderless)
        }
        .onTapGesture {
            selectSound(sound)
        }
        .sheet(isPresented: $isViewingMenu) {
            menu
            .presentationDetents([.fraction(0.4)])
        }
    }
}

struct MenuTitleRowView: View {
    let icon: String
    let sound: SoundsModel
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(minWidth: 30)
            Button {
                action()
            } label: {
                VStack(alignment: .leading) {
                    Text(sound.name)
                        .bold()
                    Text(sound.categoryName).font(.caption)
                    Text(sound.locationName).font(.caption)
                }
            }
        }
    }
}


struct MenuRowView: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(minWidth: 30)
            Button {
                action()
            } label: {
                Text(text)
            }
            .foregroundColor(Color.theme.titleColor)
            .buttonStyle(.borderless)
        }
    }
}

extension LibraryItemView {
    var menu: some View {
        VStack {
            List {
                MenuTitleRowView(
                    icon: "mic",
                    sound: sound,
                    action: {
                        isViewingMenu = false
                    }
                )
                MenuRowView(
                    icon: "play.square.fill",
                    text: "Play in tab bar player",
                    action: {
                        selectSound(sound)
                        isViewingTabPlayerView = true
                        isViewingMenu = false
                    }
                )
                MenuRowView(
                    icon: "play.rectangle.on.rectangle.fill",
                    text: "Play in full screen player",
                    action: {
                        selectSound(sound)
                        isViewingMenu = false
                        isViewingFullPlayerView = true
                    }
                )
                MenuRowView(
                    icon: "trash",
                    text: "Delete from library",
                    action: {
                        removeFromLibrary(sound)
                        isViewingMenu = false
                        isViewingFullPlayerView = false
                    }
                )
            }
            .listStyle(.plain)
            Button("Close") { isViewingMenu.toggle() }
                .padding()
        }
    }
}
struct LibraryItemView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryItemView(
            sound: dev.testSound,
            selectSound: { _ in },
            removeFromLibrary: { _ in },
            isViewingTabPlayerView: .constant(false),
            isViewingFullPlayerView: .constant(false),
            isViewingMenu: false
      
        )
    }
}
