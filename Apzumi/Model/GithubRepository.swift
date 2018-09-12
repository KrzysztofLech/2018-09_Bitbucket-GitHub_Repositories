//
//  Repository.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

struct GithubRepository: Codable {
    
    let repoName:        String
    let repoDescription: String?
    let owner:           GithubRepoOwner

    enum CodingKeys: String, CodingKey {
        case repoName        = "name"
        case repoDescription = "description"
        case owner           = "owner"
    }
}
