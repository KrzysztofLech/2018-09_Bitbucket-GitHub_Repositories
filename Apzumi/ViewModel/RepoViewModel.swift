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
    
    // MARK: - Public properties
    
    var repositoriesCount: Int {
        return repositories.count
    }
    
    var dataShouldBeSorted: Bool = false
    
    
    // MARK: - Private properties
    
    private let dataService: DataService
    private let realm = try! Realm()
    private var repositories: Results<Repository> = try! Realm().objects(Repository.self)
    private var sortedRepositories: Results<Repository>?

    
    // MARK: - Init method
    
    init(dataService: DataService = DataService()) {
        self.dataService = dataService
    }
    
    
    // MARK: - Private methods
    
    private func deleteAllData() {
        try! realm.write {
            realm.deleteAll()
            print("Realm: ALL Data Deleted!")
        }
    }
    
    private func prepareSortedData() {
        sortedRepositories = repositories.sorted(byKeyPath: "repoName", ascending: true)
    }
    
    
    // MARK: - Public methods
    
    func getData(completion: @escaping Completion) {
        deleteAllData()
        
        // GitHub data fetching
        dataService.fetchGitHubData { [unowned self] (dataArray) in

            DispatchQueue.main.async {

                try! self.realm.write {
                    self.realm.add(dataArray)
                }

                print("Dodano \(dataArray.count) elementów z GitHub")
                
                self.prepareSortedData()
                completion()
            }
        }
        
        // Bitbucket data fetching
        dataService.fetchBitbucketData { [unowned self] (dataArray) in

            DispatchQueue.main.async {
                
                try! self.realm.write {
                    self.realm.add(dataArray)
                }
                
                self.prepareSortedData()
                print("Dodano \(dataArray.count) elementów z Bitbucket")
                
                completion()
            }
        }
    }
    
    func getCellData(withIndex index: Int) -> (repoName: String, ownerName: String, avatarUrl: String, source: String) {
        let data = dataShouldBeSorted ? sortedRepositories![index] : repositories[index]
        return (data.repoName, data.ownerName, data.ownerAvatarUrl, data.repoSource)
    }

    func getDetailsData(withIndex index: Int) -> (repoName: String, ownerName: String, avatarUrl: String, description: String) {
        let data = dataShouldBeSorted ? sortedRepositories![index] : repositories[index]
        return (data.repoName, data.ownerName, data.ownerAvatarUrl, data.repoDescription)
    }
}
