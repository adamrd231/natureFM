//
//  SingleSoundPlayerView.swift
//  natureFM
//
//  Created by Adam Reed on 9/23/21.
//

import SwiftUI
import URLImage
import GoogleMobileAds
import AVKit

struct SingleSoundPlayerView: View {
    
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext
    // Fetch request to get all categories from CoreData
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var currentSound: SoundsModel
 
    
    
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
    
    
    var body: some View {

        VStack {
            // Image
            URLImage(URL(string: "\(currentSound.imageFileLink)")!) {
                // Display progress
                Image("placeholder").resizable().aspectRatio(contentMode: .fill)
            } inProgress: { progress in
                // Display progress
                Image("placeholder").resizable().aspectRatio(contentMode: .fill)
            } failure: { error, retry in
                // Display error and retry button
                VStack {
                    Text(error.localizedDescription)
                    Button("Retry", action: retry)
                }
            } content: { image in
                // Downloaded image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                
            }
            
            // Information Bar
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
                    Text(currentSound.categoryName).font(.caption)
                }
            }.padding(.trailing).padding(.leading)
            
            SongPlayerView(songURL: currentSound.audioFileLink ?? "", freeSong: currentSound.freeSong)
           
            
            Spacer()
            if purchasedSubsciption.first?.hasPurchased != true {
                Banner()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            if purchasedSubsciption.first?.hasPurchased != true {
                playInterstitial()
            }
            
        })
    }
    
    
    // Google admob interstitial video stuff
    // --------------------------------------------------------------
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
}


