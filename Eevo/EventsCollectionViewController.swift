//
//  EventsCollectionViewController.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventsCollectionViewController: LoggedInViewController ,UICollectionViewDelegate ,UICollectionViewDataSource,RNFrostedSidebarDelegate {

    @IBOutlet weak var eventCollectionView: UICollectionView!
        
    var icons:NSArray = [UIImage(named:"icon-organizers"),UIImage(named:"icon-event"),UIImage(named:"icon-feedback")]
    @IBAction func onBurger(sender: AnyObject) {
        var callout:RNFrostedSidebar = RNFrostedSidebar(images: icons)
        callout.delegate = self
        callout.show()
    }
    var eventsArray = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
        Event.loadAll { (events, error) -> () in
            self.eventsArray = events!
            self.eventCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var eventCell = collectionView.dequeueReusableCellWithReuseIdentifier("eventCollectionCell", forIndexPath: indexPath) as EventCollectionCell
        
        var event = eventsArray[indexPath.row]
        
        eventCell.eventTitle.text = event.name
//        eventCell.description.text = event.description
        eventCell.eventWhen.text = "Oct 16 , 2014 10:00 AM"
        eventCell.eventWhere.text = event.fullAddress
        eventCell.eventBackgroundImage.setImageWithURL(NSURL(string:event.eventImageUrl))
        eventCell.eventOrganizerAvatar.setImageWithURL(NSURL(string:event.organizer.user.avatarImageUrl))
        
        
        eventCell.eventOrganizerAvatar.layer.cornerRadius = 21.0;
        eventCell.eventOrganizerAvatar.layer.borderWidth = 2.0;
        eventCell.eventOrganizerAvatar.layer.borderColor = UIColor.greenColor().CGColor;
        eventCell.eventOrganizerAvatar.clipsToBounds = true;
        
        eventCell.layer.borderColor = UIColor.greenColor().CGColor
        eventCell.layer.borderWidth = 1.0 
        return eventCell
        
    }
    
    func sidebar(sidebar: RNFrostedSidebar!, didTapItemAtIndex index: UInt) {
        NSLog("Tapped at Index \(index)")
        sidebar.dismissAnimated(true)
        var nav = self.storyboard?.instantiateViewControllerWithIdentifier("mainNavId") as UINavigationController
        var navEvents = self.storyboard?.instantiateViewControllerWithIdentifier("eventsNavId") as UINavigationController
        
        if(index == 0) {
            self.presentViewController(nav, animated: true, completion: nil)
            //            self.performSegueWithIdentifier("eventsSegue", sender: nav)
        }
        
        if(index == 1) {
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
