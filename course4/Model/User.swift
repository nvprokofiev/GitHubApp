//
//  User.swift
//  course4
//
//  Created by Nikolai Prokofev on 2019-03-15.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try container.decode(String.self, forKey: .login)
        self.avatarUrl = try container.decode(String.self, forKey: .avatarUrl)
    }
}
