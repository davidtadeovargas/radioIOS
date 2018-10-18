//
//  PlayerViewController.swift
//  radio
//
//  Created by MacBook 13 on 10/9/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import AVKit



class PlayerViewController: UIViewController{
    
    /*
     Flag to check if is playing or not, initially this is playing
     */
    private var playing:DarwinBoolean = true
    
    /*
     Timer for the thread to beggin playin the music
     */
    private var gameTimer: Timer! = nil
    
    /*
     Player of the music
     */
    private var player: AVPlayer!
    
    @IBOutlet weak var volumeMaxControl: UIImageView!
    @IBOutlet weak var volumeMinControl: UIImageView!
    @IBOutlet weak var circularPlay: UIImageView!
    @IBOutlet weak var volumeContro: UISlider!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var subtittleLabel: UILabel!
    @IBOutlet weak var centralImage: UIImageView!
    @IBOutlet weak var hearthImage: UIImageView!
    @IBOutlet weak var previousImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var downImage: UIImageView!
    @IBOutlet weak var graphicMusic: UIImageView!
    
    /*
     Current radio model
     */
    private var radioModel:RadioModel! = nil
    
    /*
        Contains the mini player instance
     */
    private var miniPlayer:MiniPlayerView! = nil
    
    
    
    
    
    override func viewDidLoad() {
        
        /*
         Load the gif image
         */
        graphicMusic.loadGif(name: "loading")
        
        /*
            Event for the down button image
         */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        downImage.isUserInteractionEnabled = true
        downImage.addGestureRecognizer(tapGestureRecognizer)
        
        /*
         Banner
         */
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let smart = kGADAdSizeSmartBannerPortrait
        let banner = GADBannerView(adSize: smart)
        banner.frame.origin = CGPoint(x: 0, y: screenHeight - 50) // set your own offset
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // insert your own unit ID
        banner.rootViewController = self
        self.view.addSubview(banner)
        let request = GADRequest()
        banner.load(request)
        
        /*
            Init the labels
         */
        self.updateLabels(radioModel: radioModel)

        /*
            Touch events for volumen icons
         */
        let volumeMin = UITapGestureRecognizer(target: self, action: #selector(volumeMinTapped(tapGestureRecognizer:)))
        volumeMinControl.isUserInteractionEnabled = true
        volumeMinControl.addGestureRecognizer(volumeMin)
        let volumeMax = UITapGestureRecognizer(target: self, action: #selector(volumeMaxTapped(tapGestureRecognizer:)))
        volumeMaxControl.isUserInteractionEnabled = true
        volumeMaxControl.addGestureRecognizer(volumeMax)
        
        /*
         Create the touch events for the player controls
         */
        let previousGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(previousTapped(tapGestureRecognizer:)))
        previousImage.isUserInteractionEnabled = true
        previousImage.addGestureRecognizer(previousGestureRecognizer)
        let playGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playTapped(tapGestureRecognizer:)))
        playImage.isUserInteractionEnabled = true
        playImage.addGestureRecognizer(playGestureRecognizer)
        let forwardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forwardTapped(tapGestureRecognizer:)))
        nextImage.isUserInteractionEnabled = true
        nextImage.addGestureRecognizer(forwardGestureRecognizer)
        
        /*
         Change the icon initially to playing
         */
        playImage.image = UIImage(named: "pause_white_36dp")
        
        /*
         The loading icon initially is hidden
         */
        self.loadingImage.isHidden = true
        
        /*
            Hearth icon event touch
         */
        let tapGestureRecognizerHearth = UITapGestureRecognizer(target: self, action: #selector(heartTapped(tapGestureRecognizer:)))
        hearthImage?.isUserInteractionEnabled = true
        hearthImage?.addGestureRecognizer(tapGestureRecognizerHearth)
        
        /*
            Slider volume changes
         */
        volumeContro.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        
        /*
            Set the slider volume to the initial state
         */
       self.volumeContro.value = player.volume * 100
        print("player.volume: \(player.volume)")
        
        /*
            Circular in the background play icon
         */
        circularPlay.layer.borderWidth = 1
        circularPlay.layer.masksToBounds = false
        circularPlay.layer.borderColor = UIColor.black.cgColor
        circularPlay.layer.cornerRadius = circularPlay.frame.height/2
        circularPlay.clipsToBounds = true
        
        /*
            Remove border in circular image
         */
        self.circularPlay.layer.borderWidth = 0
        
        
        /*
         Remove border in central image
         */
        self.centralImage.layer.borderWidth = 0
        
        /*
            Set the central image
        */
        updateCentralImages()
        
        /*
         Circular image in the central image
         */
        centralImage.layer.borderWidth = 1
        centralImage.layer.masksToBounds = false
        centralImage.layer.borderColor = UIColor.black.cgColor
        centralImage.layer.cornerRadius = centralImage.frame.height/2
        centralImage.clipsToBounds = true
    }
    
    
    func updateCentralImages(){
        
        /*
         Set the central image
         */
        let imageUrlString = URLS.RADIOS_HOST + (self.miniPlayer.getCurrentRadioModel().img)!
        let imageUrl:URL = URL(string: imageUrlString)!
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            do {
                
                if imageUrl != nil {
                    
                    let imageData:NSData = try NSData(contentsOf: imageUrl)
                    
                    if imageData != nil {
                        // When from background thread, UI needs to be updated on main_queue
                        DispatchQueue.main.async {
                            
                            let image:UIImage = UIImage(data: imageData as Data)!
                            self.centralImage.image = image
                            
                            /*
                             Circula animation for the center image
                             */
                            DispatchQueue.main.async {
                                self.centralImage.rotate360Degrees(duration: 1)
                            }
                            
                            /*
                             Add the background image
                             */
                            let imageBack:UIImage = UIImage(data: imageData as Data)!
                            self.view.backgroundColor = UIColor(patternImage: imageBack)
                            
                            /*
                             Add the blur effect
                             */
                            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
                            let blurEffectView = UIVisualEffectView(effect: blurEffect)
                            blurEffectView.frame = self.view.bounds
                            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            self.view.addSubview(blurEffectView)
                            self.view.sendSubview(toBack: blurEffectView)
                        }
                    }
                }
                
            } catch _ {
            }
        }
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        // Coalesce the calls until the slider valude has not changed for 0.2 seconds
        /*debounce(seconds: 0.2) {
            print("slider value: \(sender.value)")
        }*/
        player.volume = sender.value / 100
        print("sender.value: \(player.volume)")
    }
    
    
    /*
     When the user clics on the heart icon
     */
    @objc func heartTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        /*
         Paint and validate the color of the heart
         */
        var imageHeart = ""
        if(!radioModel.hearthIt){
            
            radioModel.hearthIt = true
            imageHeart = "hearth-red"
         
            /*
             Set the false value with the server for this favorite
             */
            FavoritesSettings.shared.updateFavorite(id: radioModel.id as! Int,val: true)
        }
        else{
            radioModel.hearthIt = false
            imageHeart = "hearth-empty"
            
            /*
             Set the false value with the server for this favorite
             */
            FavoritesSettings.shared.updateFavorite(id: radioModel.id as! Int,val: false)
        }
        
        /*
            Change the image type
         */
        let image = UIImage(named: imageHeart)
        hearthImage.image = image
    }
    
    
    func pause(){
        
        /*
         If it is playing or not change the icon
         */
        playImage.image = UIImage(named: "play_arrow_white_36dp")
        
        /*
         Reset flag
         */
        playing = false
        
        player.pause()
        
        /*
            Hidde the graphic music
         */
        self.graphicMusic.isHidden = true
    }
    
    
    func play(){
        
        /*
         Change the icon
         */
        playImage.image = UIImage(named: "pause_white_36dp")
        
        /*
         Change the labels
         */
        self.tittleLabel.text = self.radioModel.name
        self.subtittleLabel.text = self.radioModel.sourceRadio
        
        /*
         Reset flag
         */
        playing = true
        
        player.play()
        
        /*
         Show the graphic music
         */
        self.graphicMusic.isHidden = false
        
        /*
         Hide the controls until the rate is playing and show loading
         */
        self.showLoading()
        self.hideControlsPlay()
        
        /*
         Start the timer to check when already is playing and show the controls
         */
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    
    /*
     Detect if already it is playing
     */
    func isPlaying()->Bool {
        if (self.player.rate != 0 && self.player.error == nil) {
            return true
        } else {
            return false
        }
    }
    
    /*
     Timer to check when already is playing and show the controls
     */
    @objc private func runTimedCode(){
        
        /*
         If tha player is already playing invalidate it
         */
        if(self.isPlaying()){
            gameTimer.invalidate() //Stop the timer
            
            /*
             Hide the loading control and show the normal controls
             */
            self.hideLoading()
            self.showControlsPlay()
        }
    }
    
    
    func showControlsPlay(){
        previousImage.isHidden = false
        playImage.isHidden = false
        nextImage.isHidden = false
    }
    
    func hideLoading(){
        loadingImage.isHidden = true
    }
    
    
    func showLoading(){
        loadingImage.isHidden = false
    }
    
    func hideControlsPlay(){
        previousImage.isHidden = true
        playImage.isHidden = true
        nextImage.isHidden = true
    }
    
    func volumeMinTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        /*
            Set all the volume to min
         */
        player.volume = 0
        self.volumeContro.value = 0
    }
    
    
    
    func volumeMaxTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        /*
         Set all the volume to max
         */
        player.volume = 1
        self.volumeContro.value = 100
    }
    
    func previousTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        
        /*
         Deliver the event
         */
        /*if(self.onForward != nil){
         self.onForward.onForward(data: tappedImage)
         }*/
        
        /*
         Play the previous song
         */
        miniPlayer.previous()
        
        /*
            Update labels
         */
        self.updateLabels(radioModel: self.miniPlayer.getCurrentRadioModel())
        
        /*
         Update the central image
         */
        updateCentralImages()
        
    }
    func playTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if(playing).boolValue{
            pause()
        }
        else{
            play()
        }
    }
    func forwardTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        /*
         Deliver the event
         */
        /*if(self.onBackward != nil){
         self.onBackward.onBackward(data: tappedImage)
         }*/
        
        /*
         Play the forward song
         */
        miniPlayer.forward()
        
        /*
         Update labels
         */
        self.updateLabels(radioModel: self.miniPlayer.getCurrentRadioModel())
        
        /*
         Update the central image
         */
        updateCentralImages()
        
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        
        /*
            Just close the player
         */
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func updateLabels(radioModel:RadioModel){
        self.tittleLabel.text = radioModel.name
        self.subtittleLabel.text = radioModel.sourceRadio
    }
    
    
    func setRadioModel(radioModel:RadioModel){
        self.radioModel = radioModel
    }
    
    func setPlayerMusic(player: AVPlayer){
        self.player = player
    }
    
    func setMiniplayer(miniPlayer:MiniPlayerView){
        self.miniPlayer = miniPlayer
    }
}
