//
//  APINetworkService.swift
//  natureFM
//
//  Created by Adam Reed on 3/19/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case encodingParametersFailed
    case decodingJSONDataFailure
}

enum APIMethod: String {
    case GET
    case POST
}

//    var devURL = "http://127.0.0.1:8000/admin/App/sound/"
//    let prodURL = "https://nature-fm.herokuapp.com/app/sound/"

enum URLs: String {
    case getSounds = "http://127.0.0.1:8000/admin/App/sound/"
}


protocol APINetworking {
    func request(with url: URL, method: APIMethod, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

protocol NatureSoundDataProtocol {
    func downloadSounds(completion: @escaping(Result<[SoundsModel], APIError>) -> Void)
}

class APINetworkService: APINetworking {
    static let shared = APINetworkService()
    
    func request(with url: URL, method: APIMethod, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
}

class NatureSoundDataService: NatureSoundDataProtocol {
    let networkService: APINetworkService
    
    init(networkService: APINetworkService) {
        self.networkService = networkService
    }
    
    func downloadSounds(completion: @escaping (Result<[SoundsModel], APIError>) -> Void) {
        guard let url = URL(string: URLs.getSounds.rawValue) else {
            completion(.failure(.invalidURL))
            return
        }
    }
    
}
