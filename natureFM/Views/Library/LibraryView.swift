import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var vm: HomeViewModel
    @StateObject var storeManager: StoreManager
    
    func delete(at offsets: IndexSet) {
        if let index = offsets.first {
            vm.downloadedContentService.deleteSound(sound: vm.portfolioSounds[index])
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Title categry picker
            ScrollView(.horizontal) {
                HStack {
                    ForEach(vm.categories) { category in
                        Text("\(category.title)")
                            .fontWeight((category.title == vm.selectedCategory) ? .medium : .light)
                            .padding(.horizontal)
                            .offset(y: (category.title == vm.selectedCategory) ? -2.0 : 0)
                            .scaleEffect((category.title == vm.selectedCategory ? 1.5 : 1.0))
                            .onTapGesture {
                                vm.selectedCategory = category.title
                            }
                    }
                }
                .padding()
            }
            
            HStack {
                Text("\(vm.portfolioSounds.count) Titles")
                    .foregroundColor(Color.theme.titleColor)
                    .fontWeight(.bold)
                Spacer()

            }
            .padding(.horizontal)
            
            List {
                ForEach(vm.portfolioSounds) { sound in
                    HStack(spacing: 10) {
                        SoundImageView(sound: sound)
                            .frame(width: 110, height: 75)
                            .clipped()
                            .shadow(radius: 3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(sound.name)
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(sound.locationName)
                                .font(.footnote)
                            Text(sound.categoryName)
                                .font(.footnote)
                            HStack(spacing: 5) {
                                Text("Length:")
                                    .font(.footnote)
                                Text(sound.duration.returnClockFormatAsString())
                                    .font(.footnote)
                            }
                        }.foregroundColor(Color.theme.titleColor)
                    }
                   
                    .onTapGesture {
                        if !vm.isViewingSongPlayerTab {
                            vm.isViewingSongPlayerTab = true
                        }
                        vm.sound = sound
                    }
                }
                .onDelete(perform: delete)
           
            }
            .listStyle(.plain)
            .sheet(isPresented: $vm.isViewingSongPlayer, content: {
                SoundPlayerView()
                    .environmentObject(vm)
                
            })
            .overlay(alignment: .bottom, content: {
                    if vm.isViewingSongPlayerTab {
                        PlayingNowBar()
                            .environmentObject(vm)
                    }
                }
            )
            if storeManager.isShowingAdvertising {
                AdmobBanner()
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(storeManager: StoreManager())
            .environmentObject(dev.homeVM)
    }
}
