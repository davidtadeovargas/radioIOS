//
//  AbstractModel.swift
//  radio
//
//  Created by MacBook 13 on 7/5/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation
import UIKit


class AbstractModel{
    
    var id:CUnsignedLong? = nil
    var name:String? = nil
    var image:String? = nil
    var isFavorite:Bool? = nil
    var gradientDrawable:CAGradientLayer? = nil
    
    
    
    init(id:CUnsignedLong,name:String,image:String){
        self.id = id
        self.name = name
        self.image = image
    }
    
    func getId()->CUnsignedLong {
        return id!
    }
    
    func setId(id:CUnsignedLong) {
        self.id = id;
    }
    
    func getName() -> String {
        return self.name!;
    }
    
    func setName(name:String) {
        self.name = name;
    }
    
    func setImage(image:String) {
        self.image = image;
    }
    
    func getImage() -> String {
        return self.image!;
    }
    
    func getArtWork(urlHost:String) -> String{
        return self.image!;
    }
    
    func getTypeName()->String?{
        return nil;
    }
    
    func getShareStr() -> String?{
        return nil;
    }
    
    func setIsFavorite() -> Bool {
        return isFavorite!;
    }
    
    func setFavorite(favorite:Bool) {
        self.isFavorite = favorite
    }
    
    func cloneObject()->AbstractModel?{
        return nil;
    }
    
    func getGradientDrawable()-> CAGradientLayer {
        return self.gradientDrawable!;
    }
    
    func setGradientDrawable(gradientDrawable:CAGradientLayer) {
        self.gradientDrawable = gradientDrawable;
    }
}
