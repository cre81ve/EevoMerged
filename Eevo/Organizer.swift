//
//  Organizer.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import Foundation


class Organizer  {
    
    var name:String!
    var id:String!
    var description:String!
    var backGroundImageUrl:String!
    var eeVoScore:String!
    var numberOfEvents:String!
    var user:User!
    
    init(org:PFObject) {
        self.description = org["summary"] as? String
        var pointerUser:PFUser!  = org["user"] as? PFUser
        self.user  = User(puser: pointerUser)
        self.name = user.name
        self.backGroundImageUrl = org["background_image_url"] as? String
        NSLog("Organizer name \(name)")
        NSLog("Organizer name \(description)")

    }
    
    class func initWithId(org:PFObject) -> Organizer{
    var query : PFQuery = PFQuery(className: "Organizer")
        var obj:PFObject = query.getObjectWithId(org.objectId)
        return Organizer(org:obj)
    }
    
    
    class func loadAll(completion: (organizers: [Organizer]?,error: NSError?)-> ()){
            var organizers = [Organizer]()
            var query : PFQuery = PFQuery(className: "Organizer")
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if(error != nil) {
                    NSLog("Error log ")

                }else {
                    var pfObjects = objects as [PFObject]
                    for organizer in pfObjects   {
                        organizers.append(Organizer(org: organizer))
                    }
                    completion(organizers: organizers, error: nil)
                }
            }
        

    }
    
    
    
    
    
    
}