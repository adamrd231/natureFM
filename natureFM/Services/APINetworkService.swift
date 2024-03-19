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


protocol APINetworking {
    func request(with url: URL, method: APIMethod, parameters: [String: Any]?, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

protocol SoundDownloadService {
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
