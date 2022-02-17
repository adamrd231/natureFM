//
//  HorizontalScrollView.swift
//  natureFM
//
//  Created by Adam Reed on 2/8/22.
//

import SwiftUI

struct HorizontalScrollView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    
    // Store manager variable for in-app purchases
    @State var storeManager: StoreManager
    
    var soundArray: [SoundsModel]
    
    @State private var showingAlert: Bool = false
    
    var subscriptionNotPurchasedAlert = Alert(
        title: Text("Not Available."),
        message: Text("You must have a subscription to access this premium content."),
        dismissButton: .default(Text("Done")))

    var body: some View {
        HStack(spacing: 50) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(soundArray) { sound in
                        VStack(alignment: .leading, spacing: 10) {
                            SoundImageView(sound: sound)
                                .frame(width: 200, height: 150)
                                .clipped()
                                .shadow(radius: 3)
                               
                            HStack {
        
                                Button(action: {
                                    // Before saving sound, check if its a free sound or user has membership
                                    if sound.freeSong || storeManager.purchasedRemoveAds {
                                        print("Downloadiiiiing")
                                        vm.downloadedContentService.saveSound(sound: sound)
                                    } else {
                                        print("Cant Download")
                                        showingAlert = true
                                        
                                    }
                                    
                                   
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                                
                                .foregroundColor(Color.theme.titleColor)
                                
                                VStack(alignment: .leading) {
                                    Text(sound.name).font(.subheadline)
                                    Text(sound.freeSong ? "Free" : "Subscription")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 5)
                                        .background(sound.freeSong ? Color.theme.customYellow : Color.theme.customBlue)
                                        
                                   
                                }
                                .alert(isPresented: $showingAlert, content: {
                                    // decide which alert to show
                                   return subscriptionNotPurchasedAlert
                                    
                                })
                                .foregroundColor(Color.theme.titleColor)
                                Spacer()
                            }
                        }.padding(.trailing, 3)
                    }
                }
            }
        }
    }
}

struct HorizontalScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalScrollView(storeManager: StoreManager(), soundArray: [SoundsModel(), SoundsModel()])
    }
}
