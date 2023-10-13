import SwiftUI
import Combine

class AsyncSoundImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    private let url: String
    private var cancellable = Set<AnyCancellable>()
    
    init(url: String) {
        self.isLoading = true
        self.url = url
//        self.dataService = SoundImageService(soundModel: sound)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
//        dataService.$image
//            .sink { [weak self] (_) in
//                self?.isLoading = false
//
//            } receiveValue: { [weak self] (returnedImage) in
//                self?.image = returnedImage
//            }
//            .store(in: &cancellable)

    }
}
