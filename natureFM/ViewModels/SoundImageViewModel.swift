
import Foundation
import SwiftUI
import Combine

class SoundImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let sound: SoundsModel
    private let dataService: SoundImageService
    private var cancellable = Set<AnyCancellable>()
    
    init(sound: SoundsModel) {
        self.isLoading = true
        self.sound = sound
        self.dataService = SoundImageService(soundModel: sound)
        self.addSubscribers()
    }
    
    func updateImage() {
        dataService.getSoundImage(sound: sound)
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false

            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellable)

    }
}
