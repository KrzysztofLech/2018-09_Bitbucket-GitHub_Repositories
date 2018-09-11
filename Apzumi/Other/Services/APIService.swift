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
    
    
}
