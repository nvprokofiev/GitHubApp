//
//  RepositoryAuthor.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-13.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation

struct RepositoryAuthor: Decodable {
    let name: String
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarUrl = "avatar_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
    }

}
