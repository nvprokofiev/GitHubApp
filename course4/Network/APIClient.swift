//
//  APIClient.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-02-28.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation

public typealias Parameters = [String:Any]

enum APIClient {
    
    enum ListOrder: String {
        case acs
        case desc
    }
    
    case search(repository: String, language: String, order: ListOrder)
}

extension APIClient {
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        return "api.github.com"
    }
    
    private var path: String {
        switch self {
            case .search:
                return "/search/repositories"
        }
    }
    
    private var HTTPmethod: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    private var queryItems: [URLQueryItem]? {
        
        var parameters: Parameters = [:]
        var queryItems: [URLQueryItem]? = nil
        
        switch self {
        case .search(let repository, let language, let order):
            parameters = [
                "q": "\(repository)+\(language)",
                "sort": "stars",
                "order": order
            ]
        }
        
        for (key,value) in parameters {
            
            if queryItems == nil {
                queryItems = []
            }
            
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems?.append(queryItem)
        }
        
        return queryItems
    }
    
    var request: URLRequest? {
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPmethod
        return request
        
    }
}
