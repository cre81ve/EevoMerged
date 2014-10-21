//
//  Event.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import Foundation


class Event {
    
    var id :String!
    var name:String!
    var description:String!
    var address:String!
    var city:String!
    var regionOrState:String!
    var country:String!
    var eventImage:PFFile!
    var eventFromDate:String!
    var date_eventFromDate:NSDate!
    var eventToDate:String!
    var date_eventToDate:NSDate!
    var eventCategory:String!
    var organizer:Organizer!
    var marketRegion:String!
    var fullAddress:String!
    
    init(ev:PFObject) {
        self.name = ev["name"] as? String
        self.id = ev.objectId
        self.description = ev["description"] as? String
        self.eventImage = ev["image_large"] as? PFFile
        self.date_eventFromDate = ev["from_date"] as? NSDate
        self.address = ev["address"] as? String
        self.country = ev["country"] as? String
        self.city = ev["city"] as? String
        self.regionOrState = ev["region"] as? String
        
        self.fullAddress = "\(address), \(city), \(regionOrState), \(country) "
        
        var organizerObject:PFObject = ev["organizer"] as PFObject
        self.organizer = Organizer.initWithId(organizerObject)
    }
    
    
    class func loadAll(completion: (events: [Event]?,error: NSError?)-> ()){
        var events = [Event]()
        var query : PFQuery = PFQuery(className: "Event")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error != nil {
                println("Event#loadAll failed: \(error)")
                
            } else {
                var pfObjects = objects as [PFObject]
                for event in pfObjects   {
                    events.append(Event(ev: event))
                }
                completion(events: events, error: nil)
            }
        }
    }
}