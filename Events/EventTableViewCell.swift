//
//  EventTableViewCell.swift
//  Events
//
//  Created by niels on 28/11/15.
//  Copyright © 2015 niels. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    //MARK:Properties
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
