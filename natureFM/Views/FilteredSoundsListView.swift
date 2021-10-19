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
    
    // Current Search Text
    @State var currentText = ""
    
    // FetchRequest allows us to apply filters with predicate based on user inputs
    var fetchRequest: FetchRequest<Sound>
    
    // Coredata sounds variable
    var sounds: FetchedResults<Sound> {
        fetchRequest.wrappedValue
    }
    
    // Function to remove item from CoreData, accepts the coredata item to be deleted
    func removeObjectFromCoreData(item: Sound) {
        // Delete item
        managedObjectContext.delete(item)
        // Save CoreData
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
            print("Error deleting and saving the database after")
        }
    }
    
    // Initializing the wrapped value to act as a filter on coredata, accepts category filter and searchtext filter
    init(filter: String, searchText: String) {
        
        // Verify if user has made any inputs
        if searchText == "" {
            if filter == "All" {
            // No Inputs
            // Search with no sound or category filters
            fetchRequest = FetchRequest<Sound>(entity: Sound.entity(),
                                               sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)])
            } else {
                // Category Input
                // Search for sounds with category filter only
                fetchRequest = FetchRequest<Sound>(
                    entity: Sound.entity(),
                    sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)],
                    predicate: NSPredicate(format:"categoryName == %@", filter))
            }
        } else {
            if filter != "All" {
                // Category Input and SearchText input
                // Search for sounds with category and searchtext filters
                fetchRequest = FetchRequest<Sound>(
                    entity: Sound.entity(),
                    sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)],
                    predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format:"name BEGINSWITH[c] %@", searchText), NSPredicate(format:"categoryName == %@", filter)]))
            } else {
                // SearchText input
                // Search for sounds by searchtext filter only
                fetchRequest = FetchRequest<Sound>(
                    entity: Sound.entity(),
                    sortDescriptors: [NSSortDescriptor(keyPath: \Sound.name, ascending: true)],
                    predicate: NSPredicate(format:"name BEGINSWITH[c] %@", searchText))
            }
        }
    }
    
    
    var body: some View {
        // Container for the TableView
        ScrollView {
            // If the filtered data model is empty show users that their library is empty
            if fetchRequest.wrappedValue.count == 0 {
                Text("Nothing in Library")
                    .font(.subheadline)
                    .padding()
            // Otherwise, show all of the content in filtered data model
            } else {
                // Loop through the items in filtered data model
                ForEach(fetchRequest.wrappedValue, id: \.self) { sound in
                    // Container
                    VStack {
                        // Stacking Image, with color overlay, with key content information
                        ZStack {
                            ImageWithURL(sound.imageFileLink ?? "placeholder")
                            Color(.black).opacity(0.5)
                            
                            // Information about the songtrack
                            VStack {
                                Text(sound.name ?? "").foregroundColor(.white).font(.title2).bold()
                                Text("Category").foregroundColor(.white).font(.subheadline).bold()
                                Text(sound.categoryName ?? "").foregroundColor(.white).font(.footnote)
                                Text("Location").foregroundColor(.white).font(.subheadline).bold()
                                Text(sound.locationName ?? "").foregroundColor(.white).font(.footnote)
                                NavigationLink(destination: CoreDataSoundPlayerView(currentSound: sound)) {
                                    Text((purchasedSubsciption.first?.hasPurchased == true || sound.freeSong == true) ? "Tune-In" : "Get Subcription")
                                        .padding()
                                        .background(Color(.systemGray))
                                        .cornerRadius(15)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        // Accessort Information Bar along bottom of stacked image container
                        HStack {
                            // Inform users if content is free or not
                            Text((sound.freeSong == true) ? "Free Song" : "Premium Content").font(.footnote)
                            Spacer()
                            Button(action: {
                                // Remove object from users library
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

