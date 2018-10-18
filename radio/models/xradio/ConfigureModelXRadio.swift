//
//  ConfigureModel.swift
//  radio
//
//  Created by MacBook 13 on 7/13/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation

class ConfigureModelXRadio{
    
    var apiKey:String? = nil;
    var lastFmApiKey:String? = nil;
    var cacheExpiration:Int? = nil;
    var urlEndPoint:String? = nil;
    var adType:String? = nil;
    var bannerId:String? = nil;
    var interstitialId:String? = nil;
    var appId:String? = nil;
    
    
    
    
    func getAdType()->String {
        return adType!;
    }
    
    func getBannerId()->String {
        return bannerId!;
    }
    
    func getInterstitialId()->String {
        return interstitialId!;
    }
    
    func getAppId()->String {
        return appId!;
    }
    
    func getApiKey()->String {
        return apiKey!;
    }
    
    func getUrlEndPoint()->String {
        return urlEndPoint!;
    }
    
    func isOnlineApp()->Bool{
        return !urlEndPoint!.isEmpty;
    }
    
    func getLastFmApiKey()->String {
        return lastFmApiKey!;
    }
    
    func getCacheExpiration()->Int {
        return cacheExpiration!;
    }
}
