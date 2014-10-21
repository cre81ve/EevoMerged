//
//  Organizer.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import Foundation


class Organizer  {
    
    var pfOrganizer: PFObject!
    var name:String!
    var id:String!
    var description:String!
    var backgroundImage: PFFile!
    var eeVoScore:String!
    var numberOfEvents:String!
    var user:User!
    
    init(org:PFObject) {
        self.pfOrganizer = org
        self.description = org["summary"] as? String
        var pointerUser:PFUser!  = org["user"] as? PFUser
        self.user  = User(puser: pointerUser)
        self.name = user.name
        self.backgroundImage = org["background_image"] as? PFFile
        NSLog("Organizer name \(name)")
        NSLog("Organizer name \(description)")

    }
    
    class func initWithId(org:PFObject) -> Organizer {
        var query : PFQuery = PFQuery(className: "Organizer")
        var obj:PFObject = query.getObjectWithId(org.objectId)
        return Organizer(org:obj)
    }
    
    class func loadAll(completion: (organizers: [Organizer]?,error: NSError?)-> ()){
        var organizers = [Organizer]()
        var query : PFQuery = PFQuery(className: "Organizer")
        query.includeKey("user")
        //query.includeKey("background_image")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error != nil {
                println("Organizer#loadAll failed: \(error)")
            } else {
                var pfObjects = objects as [PFObject]
                for organizer in pfObjects   {
                    organizers.append(Organizer(org: organizer))
                }
                completion(organizers: organizers, error: nil)
            }
        }
    }
}