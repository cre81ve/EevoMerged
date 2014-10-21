//
//  User.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import Foundation


class User {

    var userName: String!
    var id: String!
    var password: String!
    var email: String!
    var avatarImage: PFFile!
    var name: String!
    
    init(id:String) {
        var userObj:PFObject = queryById(id)
        self.userName = userObj["username"] as? String
        self.id = userObj["id"] as? String
        self.email = userObj["email"] as? String
        self.avatarImage = userObj["avatar_thumbnail"] as? PFFile
        self.password = userObj["password"] as? String
        self.name = userObj["name"] as? String
    }
    
    init(puser:PFUser) {
        puser.fetch()
        self.userName = puser.username
        self.id = puser.objectId
        self.email = puser.email
        self.avatarImage = puser["avatar_thumbnail"] as? PFFile
        self.password = puser.password
        self.name = puser["name"] as? String
    }
    
    func queryById(id:String)  -> PFObject{
        var query : PFQuery = PFQuery(className: "User")
        query.includeKey("avatar_thumbnail")
        var userObject:PFObject = query.getObjectWithId(id)
        return userObject
    }

}