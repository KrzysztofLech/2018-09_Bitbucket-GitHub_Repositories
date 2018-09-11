//
//  Repository.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation
import RealmSwift

class Repository: Object {
    
    @objc dynamic var repoName:        String = ""
    @objc dynamic var repoDescription: String = ""
    
    @objc dynamic var ownerName:       String = ""
    @objc dynamic var ownerAvatarUrl:  String = ""
    
    @objc dynamic var repoSource:      String = ""
    
    convenience init(repoName: String, repoDescription: String, ownerName: String, ownerAvatarUrl: String, repoSource: String) {
        self.init()
        
        self.repoName = repoName
        self.repoDescription = repoDescription
        
        self.ownerName = ownerName
        self.ownerAvatarUrl = ownerAvatarUrl
        
        self.repoSource = repoSource
    }
}
