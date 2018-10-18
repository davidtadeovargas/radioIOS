//
//  ShutdownTimer.swift
//  radio
//
//  Created by MacBook 13 on 8/27/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation




class ShutdownTimer : NSObject{
    
    static let sharedTimer: ShutdownTimer = ShutdownTimer()
    var internalTimer: Timer?
    
    
    
    /*
        Start the timer in the specified period of minutes
     */
    func startTimer(minutes:Int){
        let seconds:Double = (Double(minutes * 60))
        self.internalTimer = Timer.scheduledTimer(timeInterval: seconds /*seconds*/, target: self, selector: #selector(fireTimerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        self.internalTimer?.invalidate()
    }
    
    /*
        Event fired when time is elapsed
     */
    func fireTimerAction(sender: AnyObject?){
        
        /*
            Exit the app
         */
        exit(0)
    }
}
