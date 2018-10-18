//
//  RadiosTableViewCell.swift
//  radio
//
//  Created by MacBook 13 on 8/7/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit

class RadiosTableViewCell: UITableViewCell {

    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var hearthImageView: UIImageView!
    
    var radioModel:RadioModel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
