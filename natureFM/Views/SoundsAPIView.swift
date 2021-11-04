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
    @Binding var searchText: String
    // State variable for currently selected category in category Enum
    @Binding var selectedCategory: CurrentCategory
    
    var filteredResultArray: [SoundsModel] {
        if searchText.count == 0 && selectedCategory == .All {
            return APIresultArray
        } else if searchText.count == 0 && selectedCategory != .All {
            return APIresultArray.filter { $0.categoryName == selectedCategory.rawValue }
        } else if searchText.count > 0 && selectedCategory == .All {
            return APIresultArray.filter { $0.name.contains(searchText) }
        } else {
            return APIresultArray.filter ({ $0.name.contains(searchText) && $0.categoryName == selectedCategory.rawValue})
        }
    }
    // CoreData Save if user has made purchase or not
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    // Fetch request to get all Sounds from CoreData
    @FetchRequest(entity: Sound.entity(), sortDescriptors: []) var sounds: FetchedResults<Sound>
    
    @State private var showingPlayer = false
    
    @State var songVariable = SoundsModel()
    
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
    }

    func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("Info.plist")
    }
    
   

    
    func addSoundToUserLibrary(sound: SoundsModel) {
        
        // Save the audio file to FileManager and save the path name variable here
        guard let data = try? Data(contentsOf: URL(string: sound.audioFileLink ?? "www.rdconcepts.design")!) else { return }
        // Create URL String

        // Create the player item from URLString
        if sounds.contains(where: {$0.name == sound.name}) {
            return
        } else {
            let newSound = Sound(context: managedObjectContext)
            newSound.name = sound.name
            newSound.category = Int64(sound.category ?? 0)
            newSound.categoryName = sound.categoryName
            newSound.locationName = sound.locationName
            
            // Replace this variable with the link to the internal path
            newSound.audioFile = data
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
    
    func updateSongVariableInformation(sound: SoundsModel) {
        
        songVariable.imageFileLink = sound.imageFileLink
        songVariable.audioFileLink = sound.audioFileLink
        songVariable.categoryName = sound.categoryName
        songVariable.duration = sound.duration
        songVariable.locationName = sound.locationName
        songVariable.freeSong = sound.freeSong
    }
    
    var body: some View {

        ScrollView {
        if APIresultArray.count == 0 {
            Text("Loading Nature FM Sounds...").font(.subheadline).padding()
        } else {
        ForEach(filteredResultArray, id: \.name) { sound in
            
                VStack {
                    ZStack {
                        ZStack {
                            ImageWithURL(sound.imageFileLink)
                            Color(.black).opacity(0.5)
                        }
                        VStack {
                            TitleTextView(text: sound.name)
                            Text("Category").foregroundColor(.white).font(.subheadline).bold()
                            Text(sound.categoryName).foregroundColor(.white).font(.footnote)
                            Text("Location").foregroundColor(.white).font(.subheadline).bold()
                            Text(sound.locationName).foregroundColor(.white).font(.footnote)

                            HStack {
                                Spacer()
                                Button(action: {
                                    // Update state variable with information from selection
                                    updateSongVariableInformation(sound: sound)
                                    
                                    // Show the player after setting up the sound object with current data
                                    showingPlayer.toggle()
                                }) {
                                    Text((purchasedSubsciption.first?.hasPurchased == true || sound.freeSong == true) ? "Tune-In" : "Need Subcription")
                                        .padding()
                                        .background(Color(.systemGray))
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        .sheet(isPresented: $showingPlayer) {
                            SingleSoundPlayerView(currentSound: songVariable)
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

