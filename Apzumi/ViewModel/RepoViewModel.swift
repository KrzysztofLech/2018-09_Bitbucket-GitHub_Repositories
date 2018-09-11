//
//  RepoViewModel.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

typealias Completion = (()->())

class RepoViewModel {
    
    var githubElementsNumber: Int = 0
    
    
    // MARK: - Private properties
    
    private let apiService: APIService
    
    private var githubRepositories: [GithubRepository] = []
    
    // MARK: - Init
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    // MARK: - Networking
    
    func getGitHubData(completion: @escaping Completion) {
        apiService.getGitHubData { [unowned self] (dataArray) in
            self.githubRepositories = dataArray
            self.githubElementsNumber = dataArray.count
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getGithubCellData(withIndex index: Int) -> (repoName: String, ownerName: String, avatarUrl: String) {
        let repoName  = githubRepositories[index].repoName
        let ownerName = githubRepositories[index].owner.name
        let avatarUrl = githubRepositories[index].owner.avatar
        return (repoName, ownerName, avatarUrl)
    }
    
}
