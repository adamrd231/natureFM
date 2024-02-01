import SwiftUI

struct HorizontalScrollSoundView: View {
    let sound: SoundsModel
    let hasSubscription: Bool
    let userOwnsSound: Bool
    let downloadSoundToLibrary: (SoundsModel) -> Void
    @Binding var isViewingSongPlayerTab: Bool
    @Binding var tabSelection: Int
    
    @State var showingAlert: Bool = false
    
    var body: some View {
        // This should be it's own component
        VStack(alignment: .leading, spacing: 5) {
            SoundImageView(sound: sound)
                .frame(width: 300, height: 150)
                .clipped()
                .shadow(radius: 5)

  
            Button(action: {
                if sound.freeSong || hasSubscription {
                    // Download sound is allowed
                    downloadSoundToLibrary(sound)
                } else {
                    showingAlert.toggle()
                    // Could prompt user to subscription page
                }
            }) {
                HStack(spacing: 7) {
                    if userOwnsSound {
                        Image(systemName: "checkmark.circle")
                        Text("In your library")
                    } else {
                        Image(systemName: "arrow.down")
                        Text("Download")
             
                    }
                }
                .font(.callout)
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .disabled(userOwnsSound)
            .buttonStyle(BorderButton(color: Color.theme.titleColor))
            
            Text(sound.name).bold()
            Text("length: \(sound.duration.returnClockFormatAsString())")
                .foregroundColor(Color.theme.titleColor.opacity(0.66))
            Text(sound.categoryName)
                .foregroundColor(Color.theme.titleColor.opacity(0.66))
            Text(sound.freeSong ? "Free" : "Subscription")
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue)
        }
        .font(.caption)
        .alert(isPresented: $showingAlert, content: {
            // decide which alert to show
            Alert(
                title: Text("Currently not available"),
                message: Text("You must have a subscription for this premium content."),
                primaryButton: .default(Text("Store")) {
                    tabSelection = 3
                },
                secondaryButton: .cancel(Text("No thanks"))
            )
            
        })
        .frame(maxWidth: 300)
    }
}

struct HorizontalScrollSoundView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollSoundView(
            sound: dev.testSound,
            hasSubscription: false,
            userOwnsSound: true,
            downloadSoundToLibrary: { _ in },
            isViewingSongPlayerTab: .constant(true),
            tabSelection: .constant(2)
        )
    }
}
