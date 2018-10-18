//
//  themesListNetController.swift
//  radio
//
//  Created by MacBook 13 on 7/18/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation

/*
 Object implementation of:
 http://localhost/RadioAPI/admin_panel/api/api.php?method=getThemes&api_key=eHJhZGlvcGVyZmVjdGFwcA&offset=0&limit=10
 */
class ThemesListNetController:NetController,NetProtocol{
    
    var themesList = [ThemeModel]() //List of results
    var onResponseProtocol:ThemesResponseProtocol? = nil //Contains the deliver end response
    
    
    
    
    /*
     Init the class
     */
    override init() {
        super.init()
        self.responseProtocol = self //Set the response protocol
    }
    
    
    
    /*
     Init the url string
     */
    func initURL(offset:Int,limit:Int){
        
        /*
         Create the initial filter url
         */
        let newString = URLS.THEMES_WITH_PAGING_PARAMS.replacingOccurrences(of: "%offset%", with: String(offset), options: .literal, range: nil)
        let newString2 = newString.replacingOccurrences(of: "%limit%", with: String(limit), options: .literal, range: nil)
        
        /*
         Set the url
         */
        self.url = newString2 //Set the url
        
    }
    
    
    /*
     Result from webservice
     */
    internal func result(data: AnyObject) {
        
        /*
         Create the list of genres
         */
        for genre in data as! [[String: AnyObject]] {
            
            let themeModel:ThemeModel = ThemeModel()
            themeModel.id = genre["id"] as? Int
            themeModel.name = genre["name"] as? String
            themeModel.img = genre["img"] as? String
            themeModel.grad_start_color = genre["grad_start_color"] as? String
            themeModel.grad_start_color = themeModel.grad_start_color?.uppercased()
            themeModel.grad_end_color = genre["grad_end_color"] as? String
            themeModel.grad_end_color = themeModel.grad_end_color?.uppercased()
            let grad_orientation:Int = (genre["grad_orientation"] as? Int)!
            themeModel.grad_orientation = String(grad_orientation)
            
            themesList.append(themeModel)
        }
        
        /*
         Deliver result to method
         */
        self.onResponseProtocol?.result(data: themesList)
    }
}
