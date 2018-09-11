//
//  DataService.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

class DataService {
    
    // MARK: - Private properties
    
    private let apiService: APIService
    
    
    // MARK: - Init
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    
    // MARK: Public methods
    
    func fetchGitHubData(completion: @escaping ([Repository])->()) {
        apiService.getGitHubData { (dataArray) in
            var githubData: [Repository] = []
            for item in dataArray {
                let repository = Repository(repoName: item.repoName,
                                     repoDescription: item.repoDescription ?? "no description",
                                           ownerName: item.owner.name,
                                      ownerAvatarUrl: item.owner.avatar,
                                          repoSource: "GitHub")
                githubData.append(repository)
            }
            completion(githubData)
        }
    }
    
    func fetchBitbucketData(completion: @escaping ([Repository])->()) {
        apiService.getBitbucketData { (dataArray) in
            completion(dataArray)
        }
    }
}
