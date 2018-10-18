//
//  Dialog.swift
//  radio
//
//  Created by MacBook 13 on 8/2/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation
import UIKit


class Dialog{
    
    var title:String!
    var message:String!
    var uiViewController:UIViewController!
    
    init(uiViewController:UIViewController,title:String,message:String){
        
        self.uiViewController = uiViewController
        self.message = message
        self.title = title
    }
    
    
    init(uiViewController:UIViewController,message:String){
        
        self.uiViewController = uiViewController
        self.title = ""
        self.message = message
    }
    
    func showOK(){
        
        let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.uiViewController.present(alert, animated: true, completion: nil)
    }
}
