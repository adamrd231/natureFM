
import Foundation
import SwiftUI
import Combine

class SoundImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let sound: SoundsModel
    private let dataService: SoundImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(sound: SoundsModel) {
        self.isLoading = true
        self.sound = sound
        print("getting sound \(sound.name)")
        self.dataService = SoundImageService(soundModel: sound)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                print("Setting isloading to false")
                self?.isLoading = false

            } receiveValue: { [weak self] (returnedImage) in
                print("Returning image")
                print("is loading \(returnedImage)")
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
