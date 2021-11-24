//
//  SoundsTableView.swift
//  natureFM
//
//  Created by Adam Reed on 8/12/21.
//

import SwiftUI

struct SoundsTableView: View {
    
    // Core Data Manage Object Container
    @Environment(\.managedObjectContext) var managedObjectContext

    // CoreData Save if user has made purchase or not
    @FetchRequest(entity: PurchasedSubsciption.entity(), sortDescriptors: []) var purchasedSubsciption: FetchedResults<PurchasedSubsciption>
    // Fetch request to get all Sounds from CoreData
    @FetchRequest(entity: Sound.entity(), sortDescriptors: []) var sounds: FetchedResults<Sound>
    
    // Store manager variable for in-app purchases
    @StateObject var storeManager: StoreManager

    // State variable for currently selected category in downloaded content Enum
    @State var downloadedContentIndex = DownloadCategory.NatureFM
    enum DownloadCategory: String, CaseIterable, Identifiable {
        case NatureFM
        case Library
        
        var id: DownloadCategory { self }
    }
    
    // Array for holding the results from the API database, users can add songs to their phone individually
    @State var APIresultArray:[SoundsModel]  = []
    
    
    // State variable for currently selected category in category Enum
    @State var selectedCategory = CurrentCategory.All
    @State var currentSearchText: String

    
    func updateUserPurchases(hasPurchased: Bool) {

        if purchasedSubsciption.count == 1 {
            if purchasedSubsciption.first?.hasPurchased != hasPurchased {
                purchasedSubsciption.first?.hasPurchased = hasPurchased
            }
            return
        } else {
            let newItem = PurchasedSubsciption(context: managedObjectContext)
            newItem.hasPurchased = true
            
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    

    // load data from database into the program
    func loadAPIArrayWithAPIData() {

        guard let url = URL(string: "https://nature-fm.herokuapp.com/app/sound/") else {
            print("Invalid URL")
            return
        }
        print(url)
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode([SoundsModel].self, from: data) {
                    DispatchQueue.main.async {
                        self.APIresultArray = response
                        self.APIresultArray.sort(by: < )
                    }
                    return
                }
            }
        }.resume()
    }
    
    var body: some View {

            TabView {
                // First Page
                // -----------
                VStack {
                    HeaderView()
                    SearchBarView(currentSearchText: $currentSearchText)
                    CategoryPickerView(selectedCategory: $selectedCategory)
                    SoundsAPIView(APIresultArray: $APIresultArray, searchText: $currentSearchText, selectedCategory: $selectedCategory)
                    if storeManager.purchasedRemoveAds == false {
                        Banner()
                    }
                }.edgesIgnoringSafeArea(.top)
                .tabItem { VStack {
                    Text("NATURE FM")
                    Image(systemName: "antenna.radiowaves.left.and.right")
                }}
                
                // Second Page
                // -----------
                VStack {
                    HeaderView()
                    
                    SearchBarView(currentSearchText: $currentSearchText)
                    CategoryPickerView(selectedCategory: $selectedCategory)
                    FilteredSoundsListView(filter: selectedCategory.rawValue, searchText: currentSearchText)

                    if storeManager.purchasedRemoveAds == false {
                        Banner()
                    }
                }.edgesIgnoringSafeArea(.top)
                .tabItem { VStack {
                    Text("LIBRARY")
                    Image(systemName: "music.note.house")
                }}
                

                // Third Page
                // -----------
                InAppStorePurchasesView(storeManager: storeManager)
                .tabItem {
                VStack {
                    Text("In-App Purchases")
                    Image(systemName: "creditcard")
                }
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            updateUserPurchases(hasPurchased: storeManager.purchasedRemoveAds)
            loadAPIArrayWithAPIData()
        })
    }
}
    








