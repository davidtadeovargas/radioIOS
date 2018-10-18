//
//  PlayerDataModel.swift
//  radio
//
//  Created by MacBook 13 on 9/11/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation



/*
    Class to interchange data between player and ui controllers
 */
class PlayerCommonData{
    
    // Can't init is singleton
    private init() { }
    
    /*
     Singleton internal instance
     */
    static let shared = PlayerCommonData()
    
    /*
        The radio link to shared between controller and the player
     */
    var radioLink:String! = nil
}
