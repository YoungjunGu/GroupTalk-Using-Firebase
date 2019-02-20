//
//  UserService.swift
//  GroupTalk
//
//  Created by youngjun goo on 21/02/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile: User?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile: User?)->())) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile: User?
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string:photoURL) {
                
                userProfile = User(uid: snapshot.key, userName: username, photoURL: url)
            }
            
            completion(userProfile)
        })
    }
    
}
