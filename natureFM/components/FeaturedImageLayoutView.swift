import SwiftUI

struct FeaturedImageLayoutView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State var sound: SoundsModel
    
    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    @State private var isShowingAlert: Bool = false
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack(alignment: .center) {
            SoundImageView(sound: sound)
                .shadow(radius: 3)
                .edgesIgnoringSafeArea(.all)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.33)
            VStack(alignment: .center, spacing: 3) {
                Text(sound.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(sound.locationName)
                Text(sound.freeSong ? "Free" : "Subscription")
                    .padding(.horizontal, 3)
                    .padding(.vertical, 2)
                    .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue )
                
            }
            .font(.caption)
            .foregroundColor(Color.theme.titleColor)
        }
        .alert(isPresented: $isShowingAlert, content: {
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
    }
}

struct FeaturedImageLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedImageLayoutView(
            sound: dev.testSound,
            storeManager: StoreManager(),
            tabSelection: .constant(1)
        )
        .environmentObject(dev.homeVM)
    }
}
