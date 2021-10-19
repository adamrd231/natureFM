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
    
    // State variable for currently selected category in category Enum
    @State var selectedCategory = CurrentCategory.All
    
    enum CurrentCategory: String, CaseIterable, Identifiable { // <1>
        case All
        case Waves
        case Rain
        case River
        case Waterfall
        case Lightning
        
        var id: CurrentCategory { self }
    }

    // State variable for currently selected category in downloaded content Enum
    @State var downloadedContentIndex = DownloadCategory.NatureFM
    enum DownloadCategory: String, CaseIterable, Identifiable {
        case NatureFM
        case Library
        
        var id: DownloadCategory { self }
    }

    // Current search text variable for user input
    @State var currentSearchText = ""
    
    // Array for holding the results from the API database, users can add songs to their phone individually
    @State var APIresultArray:[SoundsModel]  = []
    

    
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
        GeometryReader { geo in
        NavigationView() {
            TabView {
                // First Page
                // -----------
                
                VStack {
                    ZStack(alignment: .bottom) {
                        Image("fall-leaves")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: 150)
                            .clipped()
                            
                        Color("pickerColor").frame(width: geo.size.width, height: 150).clipped()
                        VStack(alignment: .center) {
                            Text("Welcome to Nature FM").font(.title).foregroundColor(.white).bold()
                            Text("Tune in to the great outdoors").font(.subheadline).foregroundColor(.white).bold().padding(.bottom)
                        }
                    }

                    HStack {
                        TextField("Search", text: $currentSearchText)
                            
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        Button("Close") {
                            UIApplication.shared.endEditing()
                        }.foregroundColor(Color(.systemGray))
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    
                        
                // Segmented Controller

                    Picker("Favorite Color", selection: $selectedCategory, content: {
                                    ForEach(CurrentCategory.allCases, content: { category in
                                        Text(category.rawValue.capitalized).foregroundColor(Color.white)
                                    })
                    })
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading)
                        .padding(.trailing)
                    
                    Picker("Downloaded Content", selection: $downloadedContentIndex, content: {
                        ForEach(DownloadCategory.allCases, content: { category in
                            Text(category.rawValue.capitalized).foregroundColor(Color.white)
                        })
                    })
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading)
                        .padding(.trailing)
                    
                    
                    if downloadedContentIndex.rawValue == "NatureFM" {
//                        List(APIresultArray, id: \.name) { result in
//                            Text(result.name)
//                        }
                        SoundsAPIView(APIresultArray: $APIresultArray)
                    } else {
                        FilteredSoundsListView(filter: selectedCategory.rawValue, searchText: currentSearchText)
                    }
                    
//                    SoundsAPIView(APIresultArray: APIresultArray)
                
                    
                    
                    
                    
                    if storeManager.purchasedRemoveAds == false {
                        Banner()
                    }
                }
                .tabItem { VStack {
                    Text("HOME")
                    Image(systemName: "house.fill")
                }}
                .onAppear(perform: {
                    updateUserPurchases(hasPurchased: storeManager.purchasedRemoveAds)
                    loadAPIArrayWithAPIData()
                    print("API Result Array: \(APIresultArray.count)")
                    
                })
                .edgesIgnoringSafeArea(.top)

                
                // Second Page
                // -----------
                InAppStorePurchasesView(storeManager: storeManager)
                    .tabItem {
                    VStack {
                        Text("In-App Purchases")
                        Image(systemName: "pause.fill")
                    }
                }
            }
           
//            .navigationTitle(Text("Nature FM"))
        }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
    




struct SoundsTableView_Previews: PreviewProvider {
    static var previews: some View {
        SoundsTableView(storeManager: StoreManager())
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



