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
    case authenticate(username: String, password: String)
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
            case .authenticate:
                return "/user"
        }
    }
    
    private var HTTPmethod: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    private var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/vnd.github.v3+json"
        ]
    }
    
    private var headers: [String: String] {
        switch self {
        case .authenticate(let username, let password):
            
            let data = "\(username):\(password)".data(using: .utf8)
            let encodedCredentials = data?.base64EncodedString() ?? ""
            return ["Authorization": "Basic \(encodedCredentials)"]
            
        default:
            return defaultHeaders
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
        default:
            break
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
        request.allHTTPHeaderFields = headers
        return request
        
    }
}
