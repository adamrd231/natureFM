//
//  FilteredSoundsListView.swift
//  natureFM
//
//  Created by Adam Reed on 10/10/21.
//

import SwiftUI
import CoreData
import URLImage

struct FilteredSoundsListView: View {
    
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext
    // Fetch request to get all categories from CoreData
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    
    @State var currentText = ""
    
    var fetchRequest: FetchRequest<Sound>
    
    var sounds: FetchedResults<Sound> {
        fetchRequest.wrappedValue
    }
    
    func removeObjectFromCoreData(item: Sound) {
        managedObjectContext.delete(item)
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
            print("Error deleting and saving the database after")
        }
    }
    
    
    init(filter: String, searchText: String) {
        
        
        if searchText == "" {
            if filter == "All" {
            // Search with no sound or categories
            fetchRequest = FetchRequest<Sound>(entity: Sound.entity(),
                                               sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)])
            } else {
                // Search for sounds by category only
                fetchRequest = FetchRequest<Sound>(
                    entity: Sound.entity(),
                    sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)],
                    predicate: NSPredicate(format:"categoryName == %@", filter))
            }
        } else {
            if filter != "All" {
                // Search for sounds by category and name
                fetchRequest = FetchRequest<Sound>(
                    entity: Sound.entity(),
                    sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)],
                    predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format:"name BEGINSWITH[c] %@", searchText), NSPredicate(format:"categoryName == %@", filter)]))
            } else {
                // Search for sounds by name only
                fetchRequest = FetchRequest<Sound>(
                    entity: Sound.entity(),
                    sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)],
                    predicate: NSPredicate(format:"name BEGINSWITH[c] %@", searchText))
            }
        }
    }
    

    
    
    var body: some View {
        ScrollView {
            if fetchRequest.wrappedValue.count == 0 {
                Text("Nothing in Library")
                    .font(.subheadline)
                    .padding()
            } else {
                ForEach(fetchRequest.wrappedValue, id: \.self) { sound in
                    VStack {
                        ZStack {
                            ZStack {
                                ImageWithURL(sound.imageFileLink ?? "placeholder")
                                Color(.black).opacity(0.5)
                            }
                            
                            VStack {
                                Text(sound.name ?? "").foregroundColor(.white).font(.title2).bold()
                                Text("Category").foregroundColor(.white).font(.subheadline).bold()
                                Text(sound.categoryName ?? "").foregroundColor(.white).font(.footnote)
                                Text("Location").foregroundColor(.white).font(.subheadline).bold()
                                Text(sound.locationName ?? "").foregroundColor(.white).font(.footnote)
                                Text((purchasedSubsciption.first?.hasPurchased == true || sound.freeSong == true) ? "Tune-In" : "Get Subcription")
                                    .padding()
                                    .background(Color(.systemGray))
                                    .cornerRadius(15)
                                    .foregroundColor(.white)
                                
                            }
                            
        //                    NavigationLink(destination: SingleSoundPlayerView(currentSound: sound)) {
        //
        //                    }.hidden()
                        
                        }
                        
                        HStack {
                            Text((sound.freeSong == true) ? "Free Song" : "Premium Content").font(.footnote)
                            Spacer()
                            Button(action: {
                                // Add song to coredata
                                removeObjectFromCoreData(item: sound)
                            }) {
                                Text("Remove from Library")
                            }.font(.footnote).foregroundColor(.black)
                        }.padding()
                    }
                    
                    
                }
            }
       
        }
    }
}

