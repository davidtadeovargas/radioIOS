//
//  FavositeNetController.swift
//  radio
//
//  Created by MacBook 13 on 8/28/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation



class FavoriteNetController:NetController,NetProtocol {
    
    /*
        Deviver response for user for response interaction from server
     */
    private var favoriteNetResponse:FavoriteNetResponse? = nil
    
    /*
        Contains the params for the conection
     */
    private var val:Bool? = false
    private var id:Int = 0
    
    
    
    
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
    func initURL(){
        
        /*
            Set the url val (true or false) based on the specified user value for favorite or not favorite
         */
        var value:Int = 0
        if(self.val)!{
            value = 1
        }
        let newString = URLS.SET_FAVORITE.replacingOccurrences(of: "%val%", with: String(value), options: .literal, range: nil).replacingOccurrences(of: "%id%", with: String(self.id), options: .literal, range: nil)
        
        /*
         Set the url
         */
        self.url = newString //Set the url
    }
    
    
    /*
        Result from webservice
     */
    internal func result(data: AnyObject) {
        
        /*
         Deliver result to controller
         */
        self.favoriteNetResponse?.onSuccess()
    }
    
    
    /*
        Setters and getters
     */
    func setVal(val:Bool){
        self.val = val
    }
    func setID(id:Int){
        self.id = id
    }
    func setResponseListener(response:FavoriteNetResponse){
        self.favoriteNetResponse = response
    }
}
