//
//  EventDetailsViewController.swift
//  Eevo
//
//  Created by Paul Lo on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventViewController: LoggedInViewController, UITableViewDataSource, UITableViewDelegate {

    enum EventSection: Int {
        case EventRatings = 0
    }

    var event: PFObject!
    var organizer: PFObject!
    var isFromOrganizerViewController = false
    var ratingStats: [PFObject] = []
    var joined = false
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var backgroundImageView: PFImageView!
    @IBOutlet weak var organizerThumbnailView: PFImageView!
    @IBOutlet weak var attendingCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var joinOrRateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        self.eventTableView.rowHeight = 57.0
        loadFromDataSource()
    }
    
    func loadFromDataSource() {
        self.eventNameLabel.text = (event["name"] as? String)
        self.backgroundImageView.file = (event["image_large"] as? PFFile)
        self.backgroundImageView.loadInBackground()
        self.eventDescriptionLabel.text = (event["description"] as? String)
        self.eventDescriptionLabel.sizeToFit()
        if var organizer = event["organizer"] as? PFObject {
            organizer.fetchIfNeededInBackgroundWithBlock() { (object: PFObject!, error: NSError!) -> Void in
                self.organizer = object
                if var user = object["user"] as? PFObject {
                    user.fetchIfNeededInBackgroundWithBlock({ (userFetched: PFObject!, error: NSError!) -> Void in
                        self.organizerThumbnailView.file = (userFetched["avatar_thumbnail"] as? PFFile)
                        self.organizerThumbnailView.loadInBackground()
                        self.organizerThumbnailView.layer.cornerRadius = 23.0;
                        self.organizerThumbnailView.layer.borderWidth = 2.0;
                        self.organizerThumbnailView.layer.borderColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5).CGColor
                        self.organizerThumbnailView.clipsToBounds = true
                    })
                }
            }
        }
        self.attendingCountLabel.text = "22 attending"
        
        var address = (self.event["address"] as? String)
        var city = (self.event["city"] as? String)
        var region = (self.event["region"] as? String)
        if address != nil && city != nil && region != nil {
            self.addressLabel.text = "\(address!), \(city!), \(region!)"
        } else {
            self.addressLabel.text = ""
        }
        
        if var startTime = event["from_date"] as? NSDate {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MMM d, yyyy h:mm a"
            var startTimeStr = formatter.stringFromDate(startTime)
            self.eventTimeLabel.text = startTimeStr
        } else {
            self.eventTimeLabel.text = ""
        }
        
        var joinQuery = PFQuery(className: "EventParticipant")
        joinQuery.whereKey("event", equalTo: event)
        joinQuery.whereKey("user", equalTo: PFUser.currentUser())
        joinQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var joining: PFObject! = nil
            self.joined = objects != nil && !objects.isEmpty
            self.joinOrRateButton.setTitle(self.joined ? "Joined - Rate This Event" : "Join", forState: .Normal)
        }
        
        var ratingQuery = PFQuery(className: "OrganizerRatingStats")
        ratingQuery.whereKey("event", equalTo: event)
        ratingQuery.includeKey("rating_spec")
        ratingQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if objects != nil {
                for rating in objects {
                    self.ratingStats.append(rating as PFObject)
                }
            }
            self.eventTableView.reloadData()
        }
    }


    @IBAction func onOrganizerThumbnailTap(sender: AnyObject) {
        if self.isFromOrganizerViewController {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            if self.organizer != nil {
                var storyboard = UIStoryboard(name: "Organizer", bundle: nil)
                var organizerController = storyboard.instantiateViewControllerWithIdentifier("OrganizerViewController") as OrganizerViewController
                organizerController.organizer = self.organizer
                self.navigationController?.pushViewController(organizerController, animated: true)
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.ratingStats.isEmpty ? 0 : 1
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        switch EventSection(rawValue: section)! {
            case .EventRatings: title = "Event Ratings"
        }
        return title
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch EventSection(rawValue: section)! {
            case .EventRatings: count = self.ratingStats.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventRatingCell") as EventRatingCell?
        if cell == nil {
            var nib = UINib(nibName: "EventRatingCell", bundle: nil)
            var objects = nib.instantiateWithOwner(self, options: nil)
            cell = objects[0] as? EventRatingCell
        }
        var eventRating: PFObject? = nil
        switch EventSection(rawValue: indexPath.section)! {
            case .EventRatings: cell?.updateCellWithRating(self.ratingStats[indexPath.row])
        }
        cell?.selectionStyle = .None
        return cell ?? UITableViewCell()
    }
    
    @IBAction func onJoinOrRate(sender: AnyObject) {
        if self.joined {
            var rateNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("EventRateNavigationController") as UINavigationController
            var rateController = rateNavigationController.viewControllers[0] as EventRateViewController
            rateController.event = self.event
            presentViewController(rateNavigationController, animated: true, completion: nil)
            return
        }
        var joinQuery = PFQuery(className: "EventParticipant")
        joinQuery.whereKey("event", equalTo: event)
        joinQuery.whereKey("user", equalTo: PFUser.currentUser())
        joinQuery.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            var joining: PFObject! = nil
            if objects != nil && !objects.isEmpty {
                joining = objects[0] as? PFObject
            }
            if joining == nil {
                joining = PFObject(className: "EventParticipant")
                joining["user"] = PFUser.currentUser()
                joining["event"] = self.event
                joining.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    if success {
                        self.joinOrRateButton.setTitle("Joined - Rate This Event", forState: .Normal)
                        self.joined = true
                    } else {
                        self.joinOrRateButton.setTitle("Join", forState: .Normal)
                        self.joined = false
                    }
                    
                })
            }
            self.joinOrRateButton.setTitle(self.joined ? "Joined" : "Join", forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
