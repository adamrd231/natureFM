import Foundation
import Combine

class NatureSoundDataService {
    @Published var allSounds: [SoundsModel] = []
    @Published var isLoading: Bool = false
    var soundSubcription: AnyCancellable?
    
    init() {
        isLoading = true
        getSounds()
    }
    
    func getSounds() {
        // Download sounds from backend
        guard let url = URL(string: "https://nature-fm.herokuapp.com/app/sound/")
     else {
            print("Error getting URL String")
            isLoading = false
            return
        }
        
        soundSubcription = NetworkingManager.download(url: url)
            .decode(type: [SoundsModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { (returnedSounds) in
                self.allSounds = returnedSounds
                self.soundSubcription?.cancel()
                self.isLoading = false
            })
    }
    
}
