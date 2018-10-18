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
 http://localhost/RadioAPI/admin_panel/api/api.php?method=getRadios&api_key=eHJhZGlvcGVyZmVjdGFwcA&offset=0&limit=10&radio_id=
 */
class RadiosListNetController:NetController,NetProtocol{
    
    var radiosList = [RadioModel]() //List of results
    var onResponseProtocol:RadiosResponseProtocol? = nil //Contains the deliver end response
    
    
    
    
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
    func initURL(offset:Int,limit:Int, query:String){
        
        /*
         Create the initial filter url
         */
        let newString = URLS.RADIOS_LIST_WITH_PAGING_PARAMS.replacingOccurrences(of: "%offset%", with: String(offset), options: .literal, range: nil)
        let newString2 = newString.replacingOccurrences(of: "%limit%", with: String(limit), options: .literal, range: nil)
        let newString3 = newString2.replacingOccurrences(of: "%q%", with: query, options: .literal, range: nil)
        
        print(newString3)
        
        /*
         Set the url
         */
        self.url = newString3 //Set the url
    }
    
    
    /*
     Result from webservice
     */
    internal func result(data: AnyObject) {
        
        /*
         Create the list of genres
         */
        for radio in data as! [[String: AnyObject]] {
            
            let radioModel:RadioModel = RadioModel()
            radioModel.id = radio["id"] as? NSNumber
            radioModel.img = radio["img"] as? String
            radioModel.linkRadio = radio["link_radio"] as? String
            radioModel.name = radio["name"] as? String
            radioModel.sourceRadio = radio["source_radio"] as? String
            radioModel.tags = radio["tags"] as? String
            radioModel.typeRadio = radio["type_radio"] as? String
            radioModel.urlFacebook = radio["url_facebook"] as? String
            radioModel.urlInstagram = radio["url_instagram"] as? String
            radioModel.urlTwitter = radio["url_twitter"] as? String
            radioModel.urlWebsite = radio["url_website"] as? String
            radioModel.userAgentRadio = radio["user_agent_radio"] as? String
            let favorite:Bool = FavoritesSettings.shared.getFavorite(id: radioModel.id as! Int)
            radioModel.hearthIt = favorite
            radiosList.append(radioModel)
        }
        
        /*
         Deliver result to method
         */
        self.onResponseProtocol?.result(data: radiosList)
    }
}
