//
//  SingleSoundPlayerView.swift
//  natureFM
//
//  Created by Adam Reed on 9/23/21.
//

import SwiftUI
import URLImage
import GoogleMobileAds

struct SingleSoundPlayerView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var soundsModel: SoundsModel
    
    // Google admob interstitial video stuff
    @State var interstitial: GADInterstitialAd?
    var testInterstitialAd = "ca-app-pub-3940256099942544/1033173712"
    var realInterstitialAd = "ca-app-pub-4186253562269967/3751660097"
    func playInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: testInterstitialAd,
            request: request, completionHandler: { [self] ad, error in
                // Check if there is an error
                if let error = error {
                    print("There was an error: \(error)")
                    return
                }
                print("No Errors No errors no errors")
                // If no errors, create an ad and serve it
                interstitial = ad
                print(interstitial)
                if let interstitalAd = interstitial {
                    print(interstitalAd)
                    let root = UIApplication.shared.windows.last?.rootViewController
                    interstitalAd.present(fromRootViewController: root!)
                }
               
                }
            )
    }
    
    var body: some View {
        
        NavigationView {
            VStack() {
                // Image
                URLImage(URL(string: "\(soundsModel.imageFileLink)")!) { progress in
                    // Display progress
                    Image("placeholder").resizable().aspectRatio(contentMode: .fill)
                } content: { image in
                    // Downloaded image
                    image
                        .resizable()
                        .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity, minHeight: 250, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                }
                
                
               SongPlayerView()
                
                Spacer()
                Banner()
            }
            .navigationTitle(Text("\(soundsModel.name)"))
            .toolbar(content: {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Go Back")
                }
            })
            
        }.onAppear(perform: {
            if soundsModel.freeSong == true {
                playInterstitial()
            }
            
        })
        
        
            
    }
}

struct SingleSoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSoundPlayerView().environmentObject(SoundsModel())
    }
}
