import Foundation
import Combine

class NatureSoundDataService {
    @Published var allSounds: [SoundsModel] = []
    @Published var isLoading: Bool = false
    @Published var hasError: Error?
    
    var soundSubscription: AnyCancellable?
    
    var devURL = "http://127.0.0.1:8000/admin/App/sound/"
    let prodURL = "https://nature-fm.herokuapp.com/app/sound/"
    
    init() {
        isLoading = true
        getSounds()
    }
    
    func getSounds() {
        // Download sounds from backend
        guard let url = URL(string: devURL) else {
            // Handle Failure to create URL String
            print("Error getting URL String")
            isLoading = false

            return
        }
        
        soundSubscription = NetworkingManager.download(url: url)
            .decode(type: [SoundsModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished: break
                    case .failure(let error): self.hasError = error
                }
                
            }, receiveValue: { (returnedSounds) in
                self.allSounds = returnedSounds
                self.soundSubscription?.cancel()
                self.isLoading = false
            })
    }
    
}
