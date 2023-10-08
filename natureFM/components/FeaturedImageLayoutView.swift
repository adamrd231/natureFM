import SwiftUI

struct FeaturedImageLayoutView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State var sound: SoundsModel
    
    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Check this out!")
                .foregroundColor(Color.theme.titleColor)
                .font(.title2)
                .fontWeight(.bold)
            VStack(alignment: .leading) {
                      
                SoundImageView(sound: sound)
                    .shadow(radius: 3)
        
                HStack {
                    VStack(alignment: .leading) {
                        Text(sound.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(sound.locationName)
                            .font(.caption)
                        Text(sound.categoryName)
                            .font(.caption)
                        Text(sound.freeSong ? "Free" : "Subscription")
                            .padding(.horizontal, 3)
                            .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue )
                            
                            .font(.caption)
                    }
                    .foregroundColor(Color.theme.titleColor)
                    Spacer()
                    Button(action: {
                        let isSoundFree = sound.freeSong
                        let userHasSubscription = !storeManager.products.contains(where: { $0.id == StoreIDs.NatureFM })
                        print("isFree: \(isSoundFree)")
                        print("has subscription: \(userHasSubscription)")
                        
                        if isSoundFree || userHasSubscription {
                            vm.downloadedContentService.saveSound(sound: sound)
                        } else {
                            showingAlert.toggle()
                            // Could prompt user to subscription page
                        }
                    }) {
                        Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }.foregroundColor(Color.theme.titleColor)
                }
            }
        }
    }
}

struct FeaturedImageLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedImageLayoutView(sound: dev.testSound)
    }
}
