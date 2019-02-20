//
//  Post.swift
//  GroupTalk
//
//  Created by youngjun goo on 20/02/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation

class Post {
    var userId: String = ""
    var author: User
    var createdAt: Date
    
    init(userId: String, author: User,timestamp: Double) {
        self.userId = userId
        self.author = author
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
    }
}
