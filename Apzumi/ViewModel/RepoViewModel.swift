//
//  RepoViewModel.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation
import RealmSwift

typealias Completion = (()->())

class RepoViewModel: NSObject {
    
    var repositoriesCount: Int {
        return repositories.count
    }
    
    
    // MARK: - Private properties
    
    private let dataService: DataService
    private let realm = try! Realm()
    private var repositories: Results<Repository> = try! Realm().objects(Repository.self)

    
    // MARK: - Init
    
    init(dataService: DataService = DataService()) {
        self.dataService = dataService
    }
    
    
    // MARK: Private methods
    
    private func deleteAllData() {
        try! realm.write {
            realm.deleteAll()
            print("Realm: ALL Data Deleted!")
        }
    }
    
    // MARK: Public methods
    
    func getData(completion: @escaping Completion) {
        deleteAllData()
        
        // GitHub data fetching
        dataService.fetchGitHubData { [unowned self] (dataArray) in

            DispatchQueue.main.async {

                try! self.realm.write {
                    self.realm.add(dataArray)
                }

                print("Dodano \(dataArray.count) elementów z GitHub")

                completion()
            }
        }
        
        // Bitbucket data fetching
        dataService.fetchBitbucketData { [unowned self] (dataArray) in

            DispatchQueue.main.async {
                
                try! self.realm.write {
                    self.realm.add(dataArray)
                }
                
                print("Dodano \(dataArray.count) elementów z Bitbucket")
                
                completion()
            }
        }
    }
    
    func getCellData(withIndex index: Int) -> (repoName: String, ownerName: String, avatarUrl: String, source: String) {
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
