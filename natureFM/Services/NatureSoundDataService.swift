import Foundation
import Combine

class NatureSoundDataService {
    
    @Published var allSounds: [SoundsModel] = []
    var soundSubcription: AnyCancellable?
    
    init() {
        print("getting songs from database")
        getSounds()
    }
    
    func getSounds() {
        // Attempt to get URL, if not possible then return
        guard let url = URL(string: "https://nature-fm.herokuapp.com/app/sound/")
     else {
            print("Error getting URL String")
            return
            
        }
        
        soundSubcription = NetworkingManager.download(url: url)
            .decode(type: [SoundsModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { (returnedSounds) in
                
                self.allSounds = returnedSounds

                self.soundSubcription?.cancel()

            })
            
        
        
    }
    
}
