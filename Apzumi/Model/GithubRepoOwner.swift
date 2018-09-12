//
//  RepoOwner.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

struct GithubRepoOwner: Codable {
    
    let name:   String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case name   = "login"
        case avatar = "avatar_url"
    }
}
