//
//  CustomTableViewController.swift
//  radio
//
//  Created by MacBook 13 on 8/21/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation
import UIKit



/*
    Custom implementation of UITableViewController
 */
class CustomTableViewController: UITableViewController,NetError{
    
    /*
     Detects when the table scroll ends
     */
    var tableProtocol:TableProtocol? = nil
    
    var responseTableConnection:ResponseTableConnection! //Deliver results to controller
    
    /*
     Flag to check if continue or not loading at end scrolling
     */
    var continueScrolling:Bool = true
    
    /*
     Protocol to detect when the table has finished loaded
     */
    var onInitialEmptyRows:OnInitialEmptyRows? = nil
    
    /*
     Protocol to detect when the table has rows
     */
    var onRows:OnRows? = nil
    
    /*
     Protocol to detect when the table has finished loaded
     */
    var onInitialRows:OnInitialRows? = nil
    
    
    
    
    func onError(error: AnyObject) {
        
    }
}

/*
 Protocol to detect when the table initialy does not have rows
 */
protocol OnInitialEmptyRows{
    func onInitialEmptyRows()
}
protocol OnRows{
    func onRows()
}
/*
 Protocol to detect when the table has finished loaded
 */
protocol OnInitialRows{
    func onInitialRows()
}
