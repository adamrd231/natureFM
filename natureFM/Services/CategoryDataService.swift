import Foundation
import Combine

class CategoryDataService {
    
    @Published var allCategories: [CategoryModel] = []
    var categorySubscription: AnyCancellable?
    
    init() {
        print("getting categories from database")
        getCategories()
    }
    
    func getCategories() {

        guard let url = URL(string: "https://nature-fm.herokuapp.com/app/category/")
     else { return }
        
        categorySubscription =  NetworkingManager.download(url: url)
            .decode(type: [CategoryModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { (returnedCategories) in
                
                self.allCategories = returnedCategories

                self.categorySubscription?.cancel()

            })
        
        
    }
    
    
}
