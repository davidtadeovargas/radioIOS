//
//  GenresListNetController.swift
//  radio
//
//  Created by MacBook 13 on 7/18/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation

/*
 Object implementation of:
 http://localhost/RadioAPI/admin_panel/api/api.php?method=getGenres&api_key=eHJhZGlvcGVyZmVjdGFwcA
 */
class GenresListNetController:NetController,NetProtocol{
    
    var genresList = [GenreModel]() //List of results
    var onResponseProtocol:GenresResponseProtocol? = nil //Contains the deliver end response
    
    
    
    
    override init() {
        
        super.init() //Constructor
        
        self.url = URLS.GENRES_LIST //Set the url
        
        self.responseProtocol = self //Set the response protocol
    }
    
    
    /*
        Result from webservice
     */
    internal func result(data: AnyObject) {
        
        /*
            Create the list of genres
         */
        for genre in data as! [[String: AnyObject]] {
            
            let genreModel:GenreModel = GenreModel()
            genreModel.id = genre["id"] as? Int
            genreModel.name = genre["name"] as? String
            genreModel.img = genre["img"] as? String
            
            genresList.append(genreModel)
        }
        
        /*
            Deliver result to method
         */
        self.onResponseProtocol?.result(data: genresList)
    }
}
