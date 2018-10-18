//
//  SleepSettingsManager.swift
//  radio
//
//  Created by MacBook 13 on 8/27/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation



class SleepSettingsManager{
    
    // Can't init is singleton
    private init() { }
    
    /*
     Singleton internal instance
     */
    static let shared = SleepSettingsManager()
    
    
    
    
    /*
        Save the amount of minutes for sleep mode configuration
     */
    func saveMinutes(minutes:Int){
        
        /*
            Save the sleep time setting
         */
        SettingManager.saveSetting(mKey: "time_sleep", mValue: String(minutes))
        
        /*
            If the minutes are grater than 0 so
         */
        if(minutes>0){
            
            /*
                Start the timer to sleep the system
             */
            ShutdownTimer.sharedTimer.startTimer(minutes: minutes)
        }
        else{
            
            /*
                Stop the timer
             */
            ShutdownTimer.sharedTimer.stopTimer()
        }
    }
    
    /*
        Reset the value
     */
    func reset(){
        
        /*
         Save the sleep time setting
         */
        SettingManager.saveSetting(mKey: "time_sleep", mValue: String("0"))
    }
    
    /*
     Get the actual minutes of sleep time in case the user configured it
     */
    func getMinutes() -> Int{
        
        let minutes:String = SettingManager.getSetting(mKey: "time_sleep", mDefValue: "0")
        return Int(minutes)!
    }
}
