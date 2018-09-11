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
    
    var repositoriesCount: Int {
        return repositories.count
    }
    
    // MARK: - Private properties
    
    private let dataService: DataService
    
    private var repositories: [Repository] = {
        
        let bitbucketElements = 10
        let githubElements = 100
        
        var array: [Repository] = []
        array.reserveCapacity(bitbucketElements + githubElements)
        
        return array
    }()

    
    // MARK: - Init
    
    init(dataService: DataService = DataService()) {
        self.dataService = dataService
    }
    
    
    // MARK: Public methods
    
    func getData(completion: @escaping Completion) {
        repositories.removeAll(keepingCapacity: true)
        
        // GitHub data fetching
        dataService.fetchGitHubData { [unowned self] (dataArray) in
            self.repositories.append(contentsOf: dataArray)
            
            print("Dodano \(dataArray.count) elementów z GitHub")
            
            DispatchQueue.main.async {
                completion()
            }
        }
        
        // Bitbucket data fetching
        dataService.fetchBitbucketData { [unowned self] (dataArray) in
            self.repositories.append(contentsOf: dataArray)

            print("Dodano \(dataArray.count) elementów z Bitbucket")

            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getCellData(withIndex index: Int) -> (repoName: String, ownerName: String, avatarUrl: String, source: RepoSource) {
        let repoName  = repositories[index].repoName
        let ownerName = repositories[index].ownerName
        let avatarUrl = repositories[index].ownerAvatarUrl
        let source    = repositories[index].repoSource
        return (repoName, ownerName, avatarUrl, source)
    }

    func getDetailsData(withIndex index: Int) -> (repoName: String, ownerName: String, avatarUrl: String, description: String) {
        let repoName    = repositories[index].repoName
        let ownerName   = repositories[index].ownerName
        let avatarUrl   = repositories[index].ownerAvatarUrl
        let description = repositories[index].repoDescription
        return (repoName, ownerName, avatarUrl, description)
    }
}
