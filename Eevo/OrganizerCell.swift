//
//  OrganizerCell.swift
//  Eevo
//
//  Created by CK on 10/11/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class OrganizerCell: UITableViewCell {

    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var organizerDescription: UILabel!
    @IBOutlet weak var organizerName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var eeVoScore: UILabel!
    @IBOutlet weak var numberOfEvents: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
