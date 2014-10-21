//
//  EventsCollectionViewController.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventsCollectionViewController: LoggedInViewController, UITableViewDataSource, UITableViewDelegate,RNFrostedSidebarDelegate {

    enum EventsSection: Int {
        case UpcomingEvents = 0
        case PastEvents = 1
    }
    
    var upcomingEvents: [PFObject] = []
    var pastEvents: [PFObject] = []
    var icons:NSArray = [UIImage(named:"icon-organizers"),UIImage(named:"icon-event"),UIImage(named:"icon-feedback")]
    var refreshControl: UIRefreshControl? = UIRefreshControl()

    @IBOutlet weak var eventsTableView: UITableView!
    
    @IBAction func onBurger(sender: AnyObject) {
        var callout:RNFrostedSidebar = RNFrostedSidebar(images: icons)
        callout.delegate = self
        callout.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
        self.eventsTableView.rowHeight = 175.0
        
        self.refreshControl?.addTarget(self, action: "loadDataFromSource", forControlEvents: .ValueChanged)
        self.eventsTableView.addSubview(self.refreshControl!)
        
        loadDataFromSource()
    }
    
    func loadDataFromSource() {
        var query = PFQuery(className: "Event")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (events: [AnyObject]!, error: NSError!) -> Void in
            self.pastEvents = []
            self.upcomingEvents = []
            if events != nil {
                var currentTime = NSDate()
                for event in events {
                    if var fromDate = event["from_date"] as? NSDate {
                        if fromDate.compare(currentTime) == NSComparisonResult.OrderedAscending {
                            self.pastEvents.append(event as PFObject)
                        } else {
                            self.upcomingEvents.append(event as PFObject)
                        }
                        
                    }
                }
            }
            self.eventsTableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if upcomingEvents.isEmpty && pastEvents.isEmpty {
            return 0
        }
        return pastEvents.isEmpty ? 1 : 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        switch EventsSection.fromRaw(section)! {
            case .UpcomingEvents: title = "Upcoming Events"
            case .PastEvents: title = "Past Events"
        }
        return title
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 175.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch EventsSection.fromRaw(section)! {
            case .UpcomingEvents: count = self.upcomingEvents.count
            case .PastEvents: count = self.pastEvents.count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as EventSecondCell?
        if cell == nil {
            var nib = UINib(nibName: "EventCell", bundle: nil)
            var objects = nib.instantiateWithOwner(self, options: nil)
            cell = objects[0] as? EventSecondCell
        }
        var event: PFObject? = nil
        switch EventsSection.fromRaw(indexPath.section)! {
            case .UpcomingEvents: cell?.updateCellWithEvent(self.upcomingEvents[indexPath.row])
            case .PastEvents: cell?.updateCellWithEvent(self.pastEvents[indexPath.row])
        }
        cell?.showThumbnail = true
        return cell ?? UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var event: PFObject! = nil
        switch EventsSection.fromRaw(indexPath.section)! {
            case .UpcomingEvents: event = self.upcomingEvents[indexPath.row]
            case .PastEvents: event = self.pastEvents[indexPath.row]
        }
        if event != nil {
            var storyboard = UIStoryboard(name: "Event", bundle: nil)
            var eventController = storyboard.instantiateViewControllerWithIdentifier("EventViewController") as EventViewController
            eventController.event = event
            self.navigationController?.pushViewController(eventController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sidebar(sidebar: RNFrostedSidebar!, didTapItemAtIndex index: UInt) {
        NSLog("Tapped at Index \(index)")
        sidebar.dismissAnimated(true)
        var nav = self.storyboard?.instantiateViewControllerWithIdentifier("mainNavId") as UINavigationController
        var navEvents = self.storyboard?.instantiateViewControllerWithIdentifier("eventsNavId") as UINavigationController
        
        if index == 0 {
            self.presentViewController(nav, animated: true, completion: nil)
        }
        if index == 1 {
            self.presentViewController(navEvents, animated: true, completion: nil)
        }
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
