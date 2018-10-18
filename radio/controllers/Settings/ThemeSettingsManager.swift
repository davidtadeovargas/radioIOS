//
//  ThemeSettingsManager.swift
//  radio
//
//  Created by MacBook 13 on 8/7/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation
import UIKit



class ThemeSettingsManager{
    
    // Can't init is singleton
    private init() { }
    
    /*
     Singleton internal instance
     */
    static let shared = ThemeSettingsManager()
    
    /*
        Set the initial setting if not configured yet
     */
    func init_(){
        
        /*
            Check if already the app is configured
         */
        var themes_init:String = SettingManager.getSetting(mKey: "themes_init", mDefValue: "false")
        if(themes_init == "false"){
            
            /*
                Not configured so set initia settings
             */
            let themeSettingsManager:ThemeSettingsManager = ThemeSettingsManager()
            themeSettingsManager.saveInitialTheme()
        }
    }
    
    func painViewController(uiViewController:UIViewController){
        
        let themeModel:ThemeModel = self.getDefaultTheme()
        
        let gradientLeft = CAGradientLayer()
        gradientLeft.frame = uiViewController.view.bounds
        gradientLeft.colors = [ColorsUtility.hexStringToUIColor(hex: themeModel.grad_start_color!).cgColor,ColorsUtility.hexStringToUIColor(hex: themeModel.grad_end_color!).cgColor]
        gradientLeft.locations = [0.0, 1.0]
        uiViewController.view.layer.insertSublayer(gradientLeft, at: 0)
    }
    
    
    
    
    func painViewControllerAdd(uiViewController:UIViewController,gradientLeft:CAGradientLayer){
        
        let themeModel:ThemeModel = self.getDefaultTheme()
        
        gradientLeft.frame = uiViewController.view.bounds
        gradientLeft.colors = [ColorsUtility.hexStringToUIColor(hex: themeModel.grad_start_color!).cgColor,ColorsUtility.hexStringToUIColor(hex: themeModel.grad_end_color!).cgColor]
        gradientLeft.locations = [0.0, 1.0]
        uiViewController.view.layer.insertSublayer(gradientLeft, at: 0)
    }
    
    
    
    func painViewControllerUpdate(uiViewController:UIViewController,gradientLeft:CAGradientLayer){
        
        let themeModel:ThemeModel = self.getDefaultTheme()
        
        gradientLeft.colors = [ColorsUtility.hexStringToUIColor(hex: themeModel.grad_start_color!).cgColor,ColorsUtility.hexStringToUIColor(hex: themeModel.grad_end_color!).cgColor]
    }
    
    
    /*
        Return the default theme for the app
     */
    func getDefaultTheme() -> ThemeModel{
        let grad_start_color:String = SettingManager.getSetting(mKey: "grad_start_color", mDefValue: "#5271c4")
        let grad_end_color:String = SettingManager.getSetting(mKey: "grad_end_color", mDefValue: "#eca1fe")
        let grad_orientation:String = SettingManager.getSetting(mKey: "grad_orientation", mDefValue: "315")
        let themeModel:ThemeModel = ThemeModel()
        themeModel.grad_start_color = grad_start_color
        themeModel.grad_end_color = grad_end_color
        themeModel.grad_orientation = grad_orientation
        return themeModel
    }
    
    /*
        Save new app theme
     */
    func saveTheme(themeModel:ThemeModel){
        
        SettingManager.saveSetting(mKey: "grad_start_color",mValue: themeModel.grad_start_color!)
        SettingManager.saveSetting(mKey: "grad_end_color",mValue: themeModel.grad_end_color!)
        SettingManager.saveSetting(mKey: "grad_orientation",mValue: themeModel.grad_orientation!)
    }

    
    /*
        Save the initial theme settings
     */
    func saveInitialTheme(){
        
        /*
            Save the flag to know themes already are configured
         */
        SettingManager.saveSetting(mKey: "themes_init",mValue: "true")
        
        /*
            Save the theme
         */
        SettingManager.saveSetting(mKey: "grad_start_color",mValue: "#5271c4")
        SettingManager.saveSetting(mKey: "grad_end_color",mValue: "#eca1fe")
        SettingManager.saveSetting(mKey: "grad_orientation",mValue: "315")
    }
}
