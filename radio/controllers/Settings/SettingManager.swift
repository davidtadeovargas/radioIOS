//
//  SettingManager.swift
//  radio
//
//  Created by MacBook 13 on 8/7/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation




class SettingManager{
    
    static func saveSetting(mKey:String,mValue:String) -> Bool{
        
        let preferences = UserDefaults.standard
        let currentLevelKey = mKey
        preferences.setValue(mValue, forKey: currentLevelKey)
        
        //  Save to disk
        let didSave = preferences.synchronize()
        
        if !didSave {
            return false
        }
        else{
            return true
        }
    }
    
    
    static func getSetting(mKey:String,mDefValue:String)-> String {
        
        let result = UserDefaults.standard.string(forKey: mKey)
        
        if(result != nil){
            return result!
        }
        else{
            return mDefValue
        }
    }
}
