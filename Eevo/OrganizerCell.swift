//
//  OrganizerCell.swift
//  Eevo
//
//  Created by CK on 10/11/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class OrganizerCell: UITableViewCell {

    var organizer: Organizer!
    
    @IBOutlet weak var backGroundImage: PFImageView!
    @IBOutlet weak var organizerDescription: UILabel!
    @IBOutlet weak var organizerName: UILabel!
    @IBOutlet weak var avatarImage: PFImageView!
    @IBOutlet weak var eeVoScore: UILabel!
    @IBOutlet weak var numberOfEvents: UILabel!
    
    func updateCellWithOrganizer(organizer: Organizer!) {
        self.organizer = organizer
        self.organizerName.text = organizer.name
        self.organizerDescription.text = organizer.description
        if organizer.backgroundImage != nil {
            self.backGroundImage.file = organizer.backgroundImage!
            self.backGroundImage.loadInBackground()
            self.backGroundImage.clipsToBounds = true
        }
        if organizer.user.avatarImage != nil {
            self.avatarImage.file = organizer.user.avatarImage!
            self.avatarImage.loadInBackground()
            self.avatarImage.layer.cornerRadius = 23.0;
            self.avatarImage.layer.borderWidth = 2.0;
            self.avatarImage.layer.borderColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5).CGColor
            self.avatarImage.clipsToBounds = true;
        }
        var query = PFQuery(className: "Event")
        query.whereKey("organizer", equalTo: organizer.pfOrganizer)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if objects != nil && objects.count > 0 {
                self.numberOfEvents.text = "\(objects.count)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
