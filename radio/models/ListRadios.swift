//
//  ListRadios.swift
//  radio
//
//  Created by MacBook 13 on 8/20/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation


class ListRadios : ModelRequest{
    
    /*
     Contains the radio list
     */
    private var listRadios:[RadioModel]! = []
    
    
    
    
    override init(){
        listRadios = []
    }
    
    
    func setListRadios(listRadios:[RadioModel]!){
        self.listRadios = listRadios
    }
    
    func getListRadios() -> [RadioModel]!{
        return self.listRadios
    }
    
    
    func addItem(radioModel:RadioModel){
        self.listRadios.append(radioModel)
    }
}
