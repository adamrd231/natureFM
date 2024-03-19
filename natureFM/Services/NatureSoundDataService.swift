import Foundation

class NatureSoundDataService: NatureSoundDataProtocol {
    let networkService: APINetworkService
    
    init(networkService: APINetworkService) {
        self.networkService = networkService
    }
    
    func getCatalogSounds(completion: @escaping (Result<[SoundsModel], APIError>) -> Void) {
        guard let url = URL(string: URLs.getSounds.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors
            guard let unwrappedData = data, error == nil else {
                print("Error")
                completion(.failure(.requestFailed))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(.statusCodeError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([SoundsModel].self, from: unwrappedData)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(.decodingJSONDataFailure))
            }
        }.resume()
    }
}

