//
//  RadioSettingsManager.swift
//  radio
//
//  Created by MacBook 13 on 7/5/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation


class RadioSettingsManager{
    
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
    
    static func setOnline(value:Bool){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_ONLINE, mValue: String(value));
    }
    
    static func getOnline() -> Bool {
        let resultado = getSetting(mKey: IXRadioSettingConstants.KEY_ONLINE, mDefValue: "false")
        let boolValue = (Int(resultado) ?? 0) != 0
        return boolValue;
    }
    
    static func setRateApp(value:Bool){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_RATE_APP, mValue: String(value));
    }
    
    static func getRateApp() -> Bool{
        let resultado = getSetting(mKey: IXRadioSettingConstants.KEY_RATE_APP, mDefValue: "false")
        let boolValue = (Int(resultado) ?? 0) != 0
        return boolValue;
    }
    
    static func setPivotTime(value:Bool){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_PIVOT_TIME, mValue: String(value));
    }
    
    static func getPivotTime() -> CUnsignedLong{
        let resultado = getSetting(mKey: IXRadioSettingConstants.KEY_PIVOT_TIME, mDefValue: "0")
        let longValue = CUnsignedLong(resultado)
        return longValue!;
    }
    
    static func setBackgroundURL(value:String){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_BACKGROUND, mValue: String(value));
    }
    
    static func getBackgroundURL() -> String{
        
        let result = UserDefaults.standard.string(forKey: IXRadioSettingConstants.KEY_BACKGROUND)
        let mDefValue = ""
        
        if(result != nil){
            return result!
        }
        else{
            return mDefValue
        }
    }
    
    static func setStartColor(value:String){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_START_COLOR, mValue: String(value));
    }
    
    static func getStartColor()->String{
        
        let result = UserDefaults.standard.string(forKey: IXRadioSettingConstants.KEY_START_COLOR)
        let mDefValue = "#ee609c"
        
        if(result != nil){
            return result!
        }
        else{
            return mDefValue
        }
    }
    
    static func setOrientation(value:Int){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_ORIENTATION, mValue: String(value));
    }
    
    static func getOrientation()->Int {
        
        let result = UserDefaults.standard.string(forKey: IXRadioSettingConstants.KEY_ORIENTATION)
        let mDefValue = "315"
        
        if(result != nil){
            return Int(result!)!
        }
        else{
            return Int(mDefValue)!
        }
    }
    
    static func setThemeId(value:CUnsignedLong){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_THEMES_ID, mValue: String(value));
    }
    
    static func getThemeId()->Int{
        
        let result = UserDefaults.standard.string(forKey: IXRadioSettingConstants.KEY_THEMES_ID)
        let mDefValue = "0"
        
        if(result != nil){
            return Int(result!)!
        }
        else{
            return Int(mDefValue)!
        }
    }
    
    static func setEndColor(value:String){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_END_COLOR, mValue: String(value));
    }
    
    static func getEndColor()->String{
        
        let result = UserDefaults.standard.string(forKey: IXRadioSettingConstants.KEY_END_COLOR)
        let mDefValue = "#cf6cc9"
        
        if(result != nil){
            return result!
        }
        else{
            return mDefValue
        }
    }
    
    
    static func setThemId(mValue:String){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_THEMES_ID, mValue: String(mValue));
    }
    
    static func getThemId() -> Int{
    
        let result = UserDefaults.standard.string(forKey: IXRadioSettingConstants.KEY_THEMES_ID)
        let mDefValue = "0"
    
        if(result != nil){
            return Int(result!)!
        }
        else{
            return Int(mDefValue)!
        }
    }
    
    static func saveThemes(model:ThemeModel,urlHost:String){
        /*if(model.getId()>0){
            setThemId(mValue: String(model.getId()));
        }
        if(!model.getGradStartColor().isEmpty){
            setStartColor(value: model.getGradStartColor());
        }
        if(!model.getGradEndColor().isEmpty){
            setEndColor(value: model.getGradEndColor());
        }
        let artWork:String = model.getArtWork(urlHost: urlHost);
        if(!artWork.isEmpty){
            setBackgroundURL(value: artWork);
        }
        else{
            setBackgroundURL(value: "");
        }
        if(model.getGradOrientation()>0){
            setOrientation(value: model.getGradOrientation());
        }*/
    }
    
    static func getSleepMode() -> Int{
    
        let result = UserDefaults.standard.string(forKey: IXRadioSettingConstants.KEY_TIME_SLEEP)
        let mDefValue = "0"
    
        if(result != nil){
            return Int(result!)!
        }
        else{
            return Int(mDefValue)!
        }
    }
    
    static func setSleepMode(mValue:String){
        RadioSettingsManager.saveSetting(mKey: IXRadioSettingConstants.KEY_TIME_SLEEP, mValue: String(mValue));
    }
}
