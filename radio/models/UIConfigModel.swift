//
//  UIConfigModel.swift
//  radio
//
//  Created by MacBook 13 on 7/10/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation

class UIConfigModel{
    
    var isFullBg:Int? = nil
    var uiTopChart:Int?  = nil;
    var uiGenre:Int?  = nil;
    var uiFavorite:Int?  = nil;
    var uiThemes:Int?  = nil;
    var uiDetailGenre:Int?  = nil;
    var uiPlayer:Int?  = nil;
    var uiSearch:Int?  = nil;
    var appType:Int?  = nil;
    
    
    
    
    func getIsFullBg() -> Int {
        return isFullBg!;
    }
    
    func setIsFullBg(isFullBg:Int) {
        self.isFullBg = isFullBg;
    }
    
    func getUiTopChart() -> Int {
        return uiTopChart!;
    }
    
    func setUiTopChart(uiTopChart:Int) {
        self.uiTopChart = uiTopChart;
    }
    
    func getUiGenre() -> Int {
        return uiGenre!;
    }
    
    func setUiGenre(uiGenre:Int) {
        self.uiGenre = uiGenre;
    }
    
    func getUiFavorite() -> Int {
        return uiFavorite!;
    }
    
    func setUiFavorite(uiFavorite:Int) {
        self.uiFavorite = uiFavorite;
    }
    
    func getUiThemes() -> Int {
        return uiThemes!;
    }
    
    func setUiThemes(uiThemes:Int) {
        self.uiThemes = uiThemes;
    }
    
    func getUiDetailGenre() -> Int {
        return uiDetailGenre!;
    }
    
    func setUiDetailGenre(uiDetailGenre:Int){
        self.uiDetailGenre = uiDetailGenre;
    }
    
    func getUiPlayer() -> Int {
        return uiPlayer!;
    }
    
    func setUiPlayer(uiPlayer:Int) {
        self.uiPlayer = uiPlayer;
    }
    
    func getUiSearch() -> Int{
        return uiSearch!;
    }
    
    func setUiSearch(uiSearch:Int){
        self.uiSearch = uiSearch;
    }
    
    func getAppType() -> Int {
        return appType!;
    }
    
    func setAppType(appType:Int) {
        self.appType = appType;
    }
    
    func isMultiApp() -> Bool{
        return self.appType == IXRadioConstants.TYPE_APP_MULTI;
    }
}
