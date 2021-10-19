//
//  SoundsAPIView.swift
//  natureFM
//
//  Created by Adam Reed on 10/18/21.
//

import SwiftUI

struct SoundsAPIView: View {
    
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var APIresultArray:[SoundsModel]
    // CoreData Save if user has made purchase or not
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    // Fetch request to get all Sounds from CoreData
    @FetchRequest(entity: Sound.entity(), sortDescriptors: []) var sounds: FetchedResults<Sound>
    
    func addSoundToUserLibrary(sound: SoundsModel) {
        
        // Save the audio file to FileManager and save the path name variable here

        
        if sounds.contains(where: {$0.name == sound.name}) {
            return
        } else {
            let newSound = Sound(context: managedObjectContext)
            newSound.name = sound.name
            newSound.category = Int64(sound.category ?? 0)
            newSound.categoryName = sound.categoryName
            newSound.locationName = sound.locationName
            
            // Replace this variable with the link to the internal path
            newSound.audioFileLink = sound.audioFileLink
            newSound.imageFileLink = sound.imageFileLink
            newSound.duration = Int64(sound.duration)
            newSound.location = Int64(sound.location ?? 0)
            newSound.freeSong = sound.freeSong
            
            do {
                try managedObjectContext.save()
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    var body: some View {
        ScrollView {
        if APIresultArray.count == 0 {
            Text("Loading Nature FM Sounds...").font(.subheadline).padding()
        } else {
        ForEach(APIresultArray, id: \.name) { sound in
            
                VStack {
                    ZStack {
                        ZStack {
                            ImageWithURL(sound.imageFileLink)
                            Color(.black).opacity(0.5)
                        }
                        VStack {
                            Text(sound.name).foregroundColor(.white).font(.title2).bold()
                            Text("Category").foregroundColor(.white).font(.subheadline).bold()
                            Text(sound.categoryName).foregroundColor(.white).font(.footnote)
                            Text("Location").foregroundColor(.white).font(.subheadline).bold()
                            Text(sound.locationName).foregroundColor(.white).font(.footnote)
                            NavigationLink(destination: SingleSoundPlayerView(currentSound: sound)) {
                                HStack {
                                    Spacer()
                                    Text((purchasedSubsciption.first?.hasPurchased == true || sound.freeSong == true) ? "Tune-In" : "Need Subcription")
                                        .padding()
                                        .background(Color(.systemGray))
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Text((sound.freeSong == true) ? "Free Song" : "Premium Content").font(.footnote)
                        Spacer()
                        HStack {
                            Text((sound.freeSong) ? "Download to Library" : "Get Subscription to Download").font(.footnote)
                            Button(action: {
                                // Add song to coredata
                                addSoundToUserLibrary(sound: sound)
                            }) {
                                Image(systemName: "arrow.down.app").foregroundColor(.black)
                            }.disabled(sound.freeSong == false)
                        }
                        
                    }
                        .padding()
                        
                }
            }
            
        }
        }
    }
}

