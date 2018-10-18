//
//  CustomTableViewCell.swift
//  radio
//
//  Created by MacBook 13 on 7/18/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//




import UIKit

class GenresViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rigthImage: UIImageView!
    @IBOutlet weak var labelLeft: UILabel!
    @IBOutlet weak var labelRigth: UILabel!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) |  UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
        self.contentMode = UIViewContentMode.scaleAspectFit
        
        /*
            Rounded corners in both images
         */
        self.leftImage.layer.cornerRadius = 10
        self.leftImage.clipsToBounds = true
        self.rigthImage.layer.cornerRadius = 10
        self.rigthImage.clipsToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
