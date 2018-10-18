//
//  ViewController.swift
//  radio
//
//  Created by MacBook 13 on 7/3/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit


//Define admobdelegate as global variable
var admobDelegate = AdMobDelegate()

//Declare a global variable currentVc to hold reference to current view controller
var currentVc: UIViewController!

class SplashViewController: UIViewController,AdmobProtocol {
    
    @IBOutlet weak var icon: UIImageView!
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*
            Load the gif image
         */
        icon.loadGif(name: "loading")
        
        let self_:UIViewController = self //To my self
        
        /*
            Set the settings for the app
         */
        self.settings()
        
        /*
            Get the actual settings and paint the splash screen acording
         and paint the view controller with gradient
         */
        ThemeSettingsManager.shared.painViewController(uiViewController: self)
        
        
        /*
         Delay
         */
        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] timer in
            
            /*
             Show the interseptial of the window
             */
            currentVc = self_
            admobDelegate.currentVc = currentVc
            admobDelegate.admobProtocol = self_ as! AdmobProtocol
            admobDelegate.showAd()
            
            timer.invalidate() //Stop the timer
        }
    }

    
    func settings(){
        
        /*
         
         Themes:
          Set the initial setting if not configured yet
         */
        ThemeSettingsManager.shared.init_()
        
        /*
            Reset the sleep timer to 0
         */
        SleepSettingsManager.shared.reset()
    }
    
    /*
     When the ad get the event interstitialWillDismissScreen
     */
    func interstitialWillDismissScreen() {
        
        /*
         Open the next window
         */
        
        let gameScene = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
        
        
        dismiss(animated: true, completion: nil) //Close current window
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

