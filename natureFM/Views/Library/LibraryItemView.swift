import SwiftUI

struct LibraryItemView: View {
    let sound: SoundsModel
    let removeFromLibrary: (SoundsModel) -> Void
    @State var isViewingMenu: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            SoundImageView(sound: sound)
                .frame(width: 75, height: 50)
                .cornerRadius(5)
                .clipped()
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(sound.name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(sound.categoryName)
                    .font(.footnote)
                HStack(spacing: 5) {
                    Text("Length:")
                        .font(.footnote)
                    Text(sound.duration.returnClockFormatAsString())
                        .font(.footnote)
                }
            }
            .foregroundColor(Color.theme.titleColor)
            .sheet(isPresented: $isViewingMenu) {
                VStack {
                    List {
                        HStack {
                            Image(systemName: "mic")
                            VStack(alignment: .leading) {
                                Text(sound.name)
                                    .bold()
                                Text(sound.categoryName).font(.caption)
                                Text(sound.locationName).font(.caption)
                            }
                           
                        }
                        HStack {
                            Image(systemName: "trash")
                            Button("Delete from library") {
                                removeFromLibrary(sound)
                                isViewingMenu = false
                            }
                        }
                    }
                    .listStyle(.plain)
                    Button("Close") { isViewingMenu.toggle() }
                }
                .presentationDetents([.fraction(0.25)])
            }
            Spacer()
            Button {
                isViewingMenu.toggle()
            } label: {
                Image(systemName: "menucard")
            }
        }
        .padding(.horizontal)
    }
}

struct LibraryItemView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryItemView(
            sound: dev.testSound,
            removeFromLibrary: { _ in },
            isViewingMenu: false
        )
    }
}
