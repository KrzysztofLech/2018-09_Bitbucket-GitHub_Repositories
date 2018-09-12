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
    
    var bitbucketCounter: String {
        return String(bitbucketCounterInt)
    }
    
    var githubCounter: String {
        return String(githubCounterInt)
    }
    
    
    // MARK: - Private properties
    
    private let dataService: DataService
    private let realm = try! Realm()
    private var repositories: Results<Repository> = try! Realm().objects(Repository.self)
    private var sortedRepositories: Results<Repository>?
    
    private var bitbucketCounterInt: Int = 0
    private var githubCounterInt:    Int = 0

    
    // MARK: - Init method
    
    init(dataService: DataService = DataService()) {
        self.dataService = dataService
    }
    
    
    // MARK: - Private methods
    
    private func deleteAllData() {
        try! realm.write {
            realm.deleteAll()
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
                
                self.prepareSortedData()
                self.githubCounterInt = dataArray.count
                
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
                self.bitbucketCounterInt = dataArray.count
                
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
