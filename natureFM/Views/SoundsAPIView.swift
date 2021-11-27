//
//  SoundsAPIView.swift
//  natureFM
//
//  Created by Adam Reed on 10/18/21.
//

import SwiftUI

struct SoundsAPIView: View {
    
    // MARK: Data Model
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext
    // Fetch from Coredata information about if the user has made a purchase or not
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    // Fetch request to get all Sounds from CoreData
    @FetchRequest(entity: Sound.entity(), sortDescriptors: []) var sounds: FetchedResults<Sound>
    
    // Store manager variable for in-app purchases
    @StateObject var storeManager: StoreManager
    
    // Array to hold results from the API
    @Binding var APIresultArray:[SoundsModel]
    
    // State variable for user searches
    @Binding var searchText: String
    // State variable for currently selected category in category Enum
    @Binding var selectedCategory: CurrentCategory
    
    // State variable to control whether to show the sheet containing the player
    @State private var showingPlayer = false
    // State variable modeling a single song for the player to user
    @State var songVariable = SoundsModel()
    
    // I think I need this image placeholder to user to save information to the filemanager
    @State var image = UIImage(named: "placeholder")
    
    
    var downloadManager = DownloadManagerFromFileManager()
    
    // MARK: Filter results from the data model
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
    


    
    

    
    func addSoundToUserLibrary(sound: SoundsModel) {
        
        // Save Image to filemanager, get the directory name for the file and save it as the imageFileLink
        downloadManager.downloadImageFile(urlString: sound.imageFileLink, urlName: sound.name)
        let imagePath = downloadManager.getImageFileAssetReturningString(urlName: sound.name)
        // Save Audio to filemanager, get the directory name for the file and save it as the audioFileLink
        
        if let audio = sound.audioFileLink {
            downloadManager.downloadAudioFile(urlString: audio, urlName: sound.name)
        }
        
        
        
        print("the image path is \(imagePath)")

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
            newSound.audioFile = sound.audioFileLink
            newSound.imageFileLink = imagePath
            newSound.duration = Int64(sound.duration)
            newSound.location = Int64(sound.location ?? 0)
            newSound.freeSong = sound.freeSong
            
            do {
                try managedObjectContext.save()
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // Save the file to local file
        
    }
    
    func updateSongVariableInformation(sound: SoundsModel) {
        // Update all the variables needed to run the songPlayer
        songVariable.name = sound.name
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
            LoadingFromAPIView()
            
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
                                    // storeManager.transactionState == true ||
                                    Text((storeManager.transactionState == .purchased || sound.freeSong == true) ? "Tune-In" : "Need Subcription")
                                        .padding()
                                        .background(Color(.systemGray))
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                        
                                        // storeManager.transactionState == true &&
                                }.disabled(storeManager.transactionState == .purchased || sound.freeSong == false)
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
                            // storeManager.transactionState == true ||
                            Text((storeManager.transactionState == .purchased || sound.freeSong == true) ? "Download to Library" : "Get Subscription to Download").font(.footnote)
                            Button(action: {
                                // Add song to coredata
                                addSoundToUserLibrary(sound: sound)
                            }) {
                                Image(systemName: "arrow.down.app").foregroundColor(.black)
                                // storeManager.transactionState == true !=
                            }.disabled(storeManager.transactionState != .purchased && sound.freeSong == false)
                        }.onAppear( perform: {
                            print("Purchased subscription?: \(storeManager.transactionState)")
                            print("free song?: \(sound.freeSong)")
                        })
                        
                    }
                        .padding()
                        
                }
            }
            
        }
        }
    }
}

