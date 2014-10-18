//
//  OrganizersViewController.swift
//  Eevo
//
//  Created by CK on 10/11/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class OrganizersViewController: LoggedInViewController ,UITableViewDelegate ,UITableViewDataSource ,RNFrostedSidebarDelegate {
//    var icons:NSArray = [UIImage(named:"iconorganizer"),UIImage(named:"iconevent"),UIImage(named:"feedback")]

        var icons:NSArray = [UIImage(named:"icon-organizers"),UIImage(named:"icon-event"),UIImage(named:"icon-feedback")]
    @IBAction func onBurger(sender: AnyObject) {
        var callout:RNFrostedSidebar = RNFrostedSidebar(images: icons)
        callout.delegate = self
        callout.show()
    }
    @IBOutlet weak var organizersTable: UITableView!
    var organizers = [Organizer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        organizersTable.delegate = self
        organizersTable.dataSource = self
        self.organizersTable.rowHeight = UITableViewAutomaticDimension
        Organizer.loadAll { (organizers, error) -> () in
            NSLog("Got all \(organizers!.count)")
            self.organizers = organizers!
            self.organizersTable.reloadData()
        }
        
              NSLog("Organizers Count \(organizers.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizers.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var organizerCell = tableView.dequeueReusableCellWithIdentifier("organizerCell") as OrganizerCell
        var organizer:Organizer = organizers[indexPath.row]
        organizerCell.organizerName.text = organizer.name
        organizerCell.organizerDescription.text = organizer.description
        organizerCell.backGroundImage.setImageWithURL(NSURL(string:organizer.backGroundImageUrl))
        organizerCell.avatarImage.setImageWithURL(NSURL(string:organizer.user.avatarImageUrl))
        organizerCell.backGroundImage.clipsToBounds = true
        organizerCell.contentView.layer.borderColor = UIColor.blackColor().CGColor
        organizerCell.contentView.layer.borderWidth = 1.0
        
        organizerCell.avatarImage.layer.cornerRadius = 23.0;
        organizerCell.avatarImage.layer.borderWidth = 2.0;
        organizerCell.avatarImage.layer.borderColor = UIColor.greenColor().CGColor;
        organizerCell.avatarImage.clipsToBounds = true;
        return organizerCell
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
