
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
        self.sound = sound
        self.dataService = SoundImageService(soundModel: sound)
        self.addSubcribers()
        self.isLoading = true
    }
    
    private func addSubcribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
