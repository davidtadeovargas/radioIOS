//
//  WebViewController.swift
//  radio
//
//  Created by MacBook 13 on 7/4/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class WebViewController: UIViewController {

    /*
        Controls managers
     */
    @IBOutlet weak var webview_: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tituloButton: UITextField!
    /*
     End of Controls managers
     */
    
    /*
     The gradient of the window is needed locally to be updated
     */
    var gradientViewController = CAGradientLayer()
    
    
    
    
    
    /*
        Override methods
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Load the url
         */
        let myURL = URL(string: Parameters.sharedInstance.url)
        let myRequest = URLRequest(url: myURL!)
        webview_.load(myRequest)
        
        /*
            Get screen dimentions
         */
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        /*
            Google add
         */
        let smart = kGADAdSizeSmartBannerPortrait
        let banner = GADBannerView(adSize: smart)
        banner.frame.origin = CGPoint(x: 0, y: screenHeight - 50) // set your own offset
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // insert your own unit ID
        banner.rootViewController = self
        self.view.addSubview(banner)
        let request = GADRequest()
        banner.load(request)
        
        /*
         Set the tittle text
         */
        tituloButton.text = Parameters.sharedInstance.text
        
        /*
         Get the actual settings and paint the splash screen acording
         and paint the view controller with the local gradient
         */
        ThemeSettingsManager.shared.painViewControllerAdd(uiViewController: self,gradientLeft: gradientViewController)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    /*
     End of Override methods
     */
    
    
    /*
        Events methods
     */
    @IBAction func backTouch(_ sender: UIButton) {
        
        /*
         Close the current window
         */
        self.dismiss(animated: true, completion: nil)
        
        /*
            Return to previous screen
         */
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    /*
     Events methods
     */
    
}
