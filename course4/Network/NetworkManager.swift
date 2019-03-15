//
//  NetworkManager.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-02-28.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

enum Result<Success, Failture> {
    case success(Success)
    case failture(Failture)
}

enum FetchError: CustomStringConvertible {
    
    case badRequest
    case networkError(Error)
    case noData
    case decodingError
    
    var description: String {
        switch self {
        case .badRequest:
            return "Unable to configure request"
        case .decodingError:
            return "Unable to decode object"
        case .noData:
            return "No data to decode"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private var session = URLSession.shared
    
    init() {}
    
    func performSearchRepositories(_ api: APIClient, _ completion: @escaping (Result<[Repository], FetchError>) -> Void) {
        
        guard let request = api.request else {
            completion(.failture(.badRequest))
            return
        }
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failture(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failture(.noData))
                return
            }

            guard let result = try? JSONDecoder().decode(GitHubRepositoryResponse.self, from: data) else {
                completion(.failture(.decodingError))
                return
            }
            
            completion(.success(result.items))

        }.resume()
    }
}
