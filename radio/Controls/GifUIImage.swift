//
//  GifUIImage.swift
//  radio
//
//  Created by MacBook 13 on 7/3/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//  Description class: This class is a custom implementatio for manage gif images into image controls

import UIKit

class GifUIImage: UIImageView {

    //MARK: Initialization
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
