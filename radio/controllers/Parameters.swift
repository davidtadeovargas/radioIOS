//
//  File.swift
//  radio
//
//  Created by MacBook 13 on 7/4/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation
import UIKit

/*
    Class to pass parameters between ViewControllers
 */
class Parameters{
    
    static let sharedInstance = Parameters() //Contains the singleton
    
    /*
        Local variables
     */
    
    var url:String = "";
    var text:String = "";
    var UIViewController:UIViewController? = nil;
    
    /*
     End of Local variables
     */
    
    
    private init() {} //Prevent public instantiation
}
