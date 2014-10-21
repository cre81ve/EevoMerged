//
//  OrganizersViewController.swift
//  Eevo
//
//  Created by CK on 10/11/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class OrganizersViewController: LoggedInViewController ,UITableViewDelegate ,UITableViewDataSource ,RNFrostedSidebarDelegate {
    
    var icons = [
        UIImage(named: "icon-organizers")!,
        UIImage(named: "icon-event")!,
        UIImage(named: "icon-feedback")!
    ]
    var organizers = [Organizer]()
    
    @IBAction func onBurger(sender: AnyObject) {
        var callout = RNFrostedSidebar(images: self.icons)
        callout.delegate = self
        callout.show()
    }
    @IBOutlet weak var organizersTable: UITableView!
    
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
        organizerCell.updateCellWithOrganizer(organizer)        
        return organizerCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var organizer:Organizer = organizers[indexPath.row]
        var storyboard = UIStoryboard(name: "Organizer", bundle: nil)
        var organizerController = storyboard.instantiateViewControllerWithIdentifier("OrganizerViewController") as OrganizerViewController
        organizerController.organizer = organizer.pfOrganizer
        self.navigationController?.pushViewController(organizerController, animated: true)        
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
