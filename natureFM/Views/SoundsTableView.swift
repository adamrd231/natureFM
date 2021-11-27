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
                    SoundsAPIView(storeManager: storeManager, APIresultArray: $APIresultArray, searchText: $currentSearchText, selectedCategory: $selectedCategory)
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

            loadAPIArrayWithAPIData()
        })
    }
}
    








