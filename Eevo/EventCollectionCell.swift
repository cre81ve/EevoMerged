//
//  EventCollectionCell.swift
//  Eevo
//
//  Created by CK on 10/12/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class EventCollectionCell: UICollectionViewCell {
    @IBOutlet weak var numberAttending: UILabel!
    
    @IBOutlet weak var eventBackgroundImage: UIImageView!
    
    @IBOutlet weak var eventOrganizerAvatar: UIImageView!
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventWhen: UILabel!
    @IBOutlet weak var eventWhere: UILabel!
}
