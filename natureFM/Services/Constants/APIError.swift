//
//  APIError.swift
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
    case invalidResponse
    case statusCodeError
}
