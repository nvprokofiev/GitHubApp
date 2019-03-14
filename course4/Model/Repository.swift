//
//  Repository.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-13.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let description: String
    let author: RepositoryAuthor
    let urlString: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case author = "owner"
        case urlString = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        if let description = try? container.decode(String.self, forKey: .description) {
            self.description = description
        } else {
            self.description = ""
        }
        self.author = try container.decode(RepositoryAuthor.self, forKey: .author)
        self.urlString = try container.decode(String.self, forKey: .urlString)
    }
}

struct GitHubRepositoryResponse: Decodable {
    var items: [Repository]
}
