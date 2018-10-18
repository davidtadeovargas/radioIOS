//
//  FavoritesSettings.swift
//  radio
//
//  Created by MacBook 13 on 8/28/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation




class FavoritesSettings{
    
    // Can't init is singleton
    private init() { }
    
    /*
     Singleton internal instance
     */
    static let shared = FavoritesSettings()
    
    
    
    
    /*
        Save or update the favorite
     */
    func updateFavorite(id:Int,val:Bool){
        
        /*
            Create the identifier
         */
        let idString:String = "favorite-" + String(id)
        
        SettingManager.saveSetting(mKey: idString, mValue: String(val))
    }
    
    
    /*
        Get the favorite
     */
    func getFavorite(id:Int) -> Bool {
        
        /*
         Create the identifier
         */
        let idString:String = "favorite-" + String(id)
        
        /*
            Return the value
         */
        return Bool(SettingManager.getSetting(mKey: idString, mDefValue: "false"))!
    }
}
