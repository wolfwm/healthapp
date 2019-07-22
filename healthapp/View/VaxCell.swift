//
//  VaxCell.swift
//  healthapp
//
//  Created by Wolfgang Walder on 12/07/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//

import UIKit

class VaxCell: UITableViewCell {
    
    @IBOutlet weak var vaxNameLabel: UILabel!
    @IBOutlet weak var vaxDateLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var vaccine: Vaccine?
}
