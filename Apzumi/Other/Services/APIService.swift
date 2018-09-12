//
//  APIService.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation
import Alamofire

struct APIService {
    
    private let githubUrl    = "https://api.github.com/repositories"
    private let bitbucketUrl = "https://api.bitbucket.org/2.0/repositories?fields=values.name,values.owner,values.description"
    
    
    func getGitHubData(closure: @escaping (_ data: [GithubRepository]) -> ()) {
        guard let endPointUrl = URL(string: githubUrl) else {
            print("Error: Cannot create URL")
            return
        }
        
        Alamofire.request(endPointUrl)
            .responseData { (dataResponse) in
                guard let data = dataResponse.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let apiData = try decoder.decode([GithubRepository].self, from: data)
                    closure(apiData)
                } catch {
                    print("Decode error: ", error)
                }
        }
    }
    
    func getBitbucketData(closure: @escaping (_ data: [Repository]) -> ()) {
        guard let endPointUrl = URL(string: bitbucketUrl) else {
            print("Error: Cannot create URL")
            return
        }

        Alamofire.request(endPointUrl)
            .responseJSON(completionHandler: { (dataResponse) in

                if let data = dataResponse.result.value as? [String : Any] {
                    if let dataArray = data["values"] as? [[String: Any]] {

                        var repositories: [Repository] = []

                        for item in dataArray {

                            var repoName = ""
                            var repoDescription = "no description"

                            var ownerName = ""
                            var ownerAvatarUrl = ""

                            if let name = item["name"] as? String {
                                repoName = name
                            }

                            if let description = item["description"] as? String {
                                repoDescription = description
                            }

                            if let owner = item["owner"] as? [String: Any] {
                                if let name = owner["display_name"] as? String {
                                    ownerName = name
                                }

                                if
                                    let links = owner["links"] as? [String : Any],
                                    let avatar = links["avatar"] as? [String : Any],
                                    let avatarUrl = avatar["href"] as? String {

                                    ownerAvatarUrl = avatarUrl
                                }
                            }

                            let repository = Repository(repoName: repoName,
                                                 repoDescription: repoDescription,
                                                       ownerName: ownerName,
                                                  ownerAvatarUrl: ownerAvatarUrl,
                                                      repoSource: "Bitbucket")
                            repositories.append(repository)
                        }

                        closure(repositories)
                    }

                } else {
                    print("Decode error!")
                }
            })
    }
}
