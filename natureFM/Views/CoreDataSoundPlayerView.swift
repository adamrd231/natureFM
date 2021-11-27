//
//  CoreDataSoundPlayerView.swift
//  natureFM
//
//  Created by Adam Reed on 10/18/21.
//

import SwiftUI
import URLImage
import GoogleMobileAds
import AVKit

struct CoreDataSoundPlayerView: View {
    
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // Store manager variable for in-app purchases
    var hasPurchased: Bool

    @State var currentSound: SoundsModel
    // Get User Purchases
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var downloadManager = DownloadManagerFromFileManager()
    
    
    func converToClockFormat(time: Int) -> Text {
        if time > 3600 {
            return Text("\(time / 3600):0\(time % 3600):0\(time % 60)")
        } else {
            if time % 60 > 9 {
                return Text("\(time / 60):\(time % 60)")
            } else {
                return Text("\(time / 60):0\(time % 60)")
            }
        }
    }
    
    
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
                if let interstitalAd = interstitial {
                    print(interstitalAd)
                    let root = UIApplication.shared.windows.last?.rootViewController
                    interstitalAd.present(fromRootViewController: root!)
                }
               
                }
            )
    }
    

    
    var body: some View {

            VStack {
                    // Image
//                if let image = currentSound.imageFileLink {
//                    ImageWithURL(image)
//                }
                ImageFromFileManager(url: currentSound.name)
                    
                VStack {
                    Text(currentSound.name).font(.title).bold()
                    HStack {
                        Text("Location").bold()
                        Spacer()
                        Text("Category").bold()
                    }
                    HStack {
                        Text(currentSound.locationName).font(.caption)
                        Spacer()
                        Text(currentSound.locationName).font(.caption)
                    }
                }.padding(.trailing).padding(.leading)
//
//                SongPlayerView(currentURL: "currentSound.audioFileLink" ?? "nothing", freeSong: currentSound.freeSong)
                SongPlayerFromFilesView(songName: currentSound.name, freeSong: currentSound.freeSong)
                
                if hasPurchased != true {
                    Spacer()
                    Banner()
                }
            }
            
            // Play Interstitial ads when opening the player
            .onAppear(perform: {
                if hasPurchased != true {
                playInterstitial()
                }
            })
    }
}
