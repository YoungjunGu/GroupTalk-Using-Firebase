//
//  Model.swift
//  GroupTalk
//
//  Created by youngjun goo on 08/02/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation

class User: NSObject {
    var uid: String
    var userName: String
    var photoURL: URL
    
    init(uid: String, userName: String, photoURL: URL) {
        self.uid = uid
        self.userName = userName
        self.photoURL = photoURL
    }
}
