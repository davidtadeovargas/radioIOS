//
//  MiniPlayer.swift
//  radio
//
//  Created by MacBook 13 on 9/10/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class MiniPlayerView: UIView {

    @IBOutlet var contentView: UIView!
    
    /*
        Contains the link to play the streaming
     */
    private var radioModel:RadioModel! = nil
    
    /*
     Contains the radio list
     */
    private var listRadios:[RadioModel]! = []
    
    private var currentModelIndex:Int! = nil
    
    /*
        External listeners to
     */
    private var onForward:OnForwar! = nil
    private var onBackward:OnBackward! = nil
    
    /*
        Contains the actual image
     */
    private var actualImage:UIImage? = nil
    
    /*
     Contains the top viewcontroller
     */
    private var viewController:UIViewController! = nil
    
    @IBOutlet weak var previusView: UIImageView!
    @IBOutlet weak var middleView: UIImageView!
    @IBOutlet weak var forwardView: UIImageView!
    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var subtittleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    /*
     The gradient of the window is needed locally to be updated
     */
    private var gradientLeft: CAGradientLayer! = nil
    
    /*
        Player of the music
     */
    private var player: AVPlayer!
    
    /*
        Timer for the thread to beggin playin the music
     */
    private var gameTimer: Timer! = nil
    
    /*
        Flag to check if is playing or not
     */
    var playing:DarwinBoolean = false
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commongInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commongInit()
    }
    
    func setViewController(viewController:UIViewController){
        self.viewController = viewController
    }
    
    /*
        Update the translucent colors
     */
    func updateColors(){
        
        /*
         Paint with the gradiente theme the mini player
         */
        let themeModel:ThemeModel = ThemeSettingsManager.shared.getDefaultTheme()
        if(gradientLeft == nil){
            gradientLeft = CAGradientLayer()
            gradientLeft.frame = contentView.bounds
            gradientLeft.colors = [ColorsUtility.hexStringToUIColor(hex: themeModel.grad_start_color!).cgColor,ColorsUtility.hexStringToUIColor(hex: themeModel.grad_end_color!).cgColor]
            gradientLeft.locations = [0.0, 1.0]
            contentView.layer.insertSublayer(gradientLeft, at: 0)
        }
        else{
            gradientLeft.colors = [ColorsUtility.hexStringToUIColor(hex: themeModel.grad_start_color!).cgColor,ColorsUtility.hexStringToUIColor(hex: themeModel.grad_end_color!).cgColor]
        }
    }
    
    
    func commongInit(){
        Bundle.main.loadNibNamed("MiniPlayerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        /*
            Events clic to open normal player
         */
        let tap = UITapGestureRecognizer(target: self, action: #selector(MiniPlayerView.tapFunction))
        tittleLabel.isUserInteractionEnabled = true
        tittleLabel.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(MiniPlayerView.tapFunction))
        subtittleLabel.isUserInteractionEnabled = true
        subtittleLabel.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(MiniPlayerView.tapFunction))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap2)
        
        /*
            Load the gif image
         */
        loadingImage.loadGif(name: "circular_loading")
        
        /*
            Paint with the gradiente theme the mini player
         */
        updateColors()
        
        /*
            Create the touch events for the player controls
         */
        let previousGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(previousTapped(tapGestureRecognizer:)))
        previusView.isUserInteractionEnabled = true
        previusView.addGestureRecognizer(previousGestureRecognizer)
        let playGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playTapped(tapGestureRecognizer:)))
        middleView.isUserInteractionEnabled = true
        middleView.addGestureRecognizer(playGestureRecognizer)
        let forwardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forwardTapped(tapGestureRecognizer:)))
        forwardView.isUserInteractionEnabled = true
        forwardView.addGestureRecognizer(forwardGestureRecognizer)
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(appEnteredBackgound), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)*/
    }
    
    
    
    func appEnteredBackgound() {
        if let tracks = player.currentItem?.tracks {
            for track in tracks {
                if track.assetTrack.hasMediaCharacteristic(AVMediaCharacteristicVisual) {
                    track.isEnabled = false
                }
            }
        }
    }
    
    func appEnteredForeground() {
        if let tracks = player.currentItem?.tracks {
            for track in tracks {
                if track.assetTrack.hasMediaCharacteristic(AVMediaCharacteristicVisual) {
                    track.isEnabled = true
                }
            }
        }
    }
    
    /*private func updateNowPlayingInfoCenter(artwork: UIImage? = nil) {
        guard let file = currentItem else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [String: AnyObject]()
            return
        }
        if let imageURL = file.album?.imageUrl where artwork == nil {
            Haneke.Shared.imageCache.fetch(URL: imageURL, success: {image in
                self.updateNowPlayingInfoCenter(image)
            })
            return
        }
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyTitle: file.title,
            MPMediaItemPropertyAlbumTitle: file.album?.title ?? "",
            MPMediaItemPropertyArtist: file.album?.artist?.name ?? "",
            MPMediaItemPropertyPlaybackDuration: audioPlayer.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: audioPlayer.progress
        ]
        if let artwork = artwork {
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: artwork)
        }
    }*/
    
    
    
    
    func setupRemoteControl() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.previous()
            return .success
        }
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.pause()
            return .success
        }
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.forward()
            return .success
        }
    }
    
    
    func updateImage(){
        
        /*
         Set the radio image
         */
        let imageUrlString = URLS.RADIOS_HOST + (radioModel?.img)!
        let imageUrl:URL = URL(string: imageUrlString)!
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            do {
                
                if imageUrl != nil {
                    
                    let imageData:NSData = try NSData(contentsOf: imageUrl)
                    
                    if imageData != nil {
                        // When from background thread, UI needs to be updated on main_queue
                        DispatchQueue.main.async {
                            
                            self.actualImage = UIImage(data: imageData as Data)!
                            self.imageView.image = self.actualImage
                            
                            /*
                             Set the info of the music in the remote control
                             */
                            let albumArt = MPMediaItemArtwork(image: self.actualImage!)
                            let songInfo: NSMutableDictionary = [
                                MPMediaItemPropertyTitle: self.radioModel.name,
                                MPMediaItemPropertyArtist: self.radioModel.sourceRadio,
                                MPMediaItemPropertyArtwork: albumArt
                            ]
                            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo as [NSObject : AnyObject] as! [String : Any]
                            
                        }
                    }
                }
                
            } catch _ {
            }
        }
    }
    
    /*
        Common clic event when the normal player has to be open
     */
    @objc
    private func tapFunction(sender:UITapGestureRecognizer) {
        
        /*
            Open the normal player
         */
        let viewController_:PlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        viewController_.setRadioModel(radioModel: radioModel)
        viewController_.setPlayerMusic(player: player)
        viewController_.setMiniplayer(miniPlayer: self)
        viewController.present(viewController_, animated: false, completion: nil)
    }
    
    func hideControlsPlay(){
        previusView.isHidden = true
        middleView.isHidden = true
        forwardView.isHidden = true
    }
    
    func showControlsPlay(){
        previusView.isHidden = false
        middleView.isHidden = false
        forwardView.isHidden = false
    }
    
    func hideLoading(){
        loadingImage.isHidden = true
    }
    
    
    func getCurrentRadioModel() -> RadioModel {
        return radioModel
    }
    
    func showLoading(){
        loadingImage.isHidden = false
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
        previous()
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
        forward()
    }
    
    
    
    /*
        Forward radio
     */
    func forward(){
        
        if((currentModelIndex + 1 ) < self.listRadios.count){
            currentModelIndex = currentModelIndex + 1
            radioModel = self.listRadios[currentModelIndex]
            self.setURLMusic(radioModel: radioModel!)
            self.play()
        }
    }
    
    
    /*
     Previous radio
     */
    func previous(){
        
        if((currentModelIndex - 1 ) >= 0){
            currentModelIndex = currentModelIndex - 1
            radioModel = self.listRadios[currentModelIndex]
            self.setURLMusic(radioModel: radioModel!)
            self.play()
        }
    }
    
    
    func play(){
        
        setupRemoteControl()
        
        /*
            Change the icon
         */
        middleView.image = UIImage(named: "pause_white_36dp")
        
        /*
            Change the labels
         */
        self.tittleLabel.text = self.radioModel.name
        self.subtittleLabel.text = self.radioModel.sourceRadio
        
        /*
         Reset flag
         */
        playing = true
        
        // everything in here will execute on the main thread
        self.player.play()
        
        /*
            Hide the controls until the rate is playing and show loading
         */
        self.showLoading()
        self.hideControlsPlay()
        
        /*
            Start the timer to check when already is playing and show the controls
         */
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        /*
            Update the image
         */
        updateImage()
    }
    
    
    func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
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
    
    func pause(){
        
        /*
         If it is playing or not change the icon
         */
        middleView.image = UIImage(named: "play_arrow_white_36dp")
        
        /*
         Reset flag
         */
        playing = false
        
        player.pause()
    }
    
    func setURLMusic(radioModel:RadioModel){
        self.radioModel = radioModel
        
        /*
            Init the radio
         */
        let urlString:String = radioModel.linkRadio
        print(urlString)
        let url = URL.init(string: urlString)
        if(self.player != nil){
            self.player.pause()
        }
        self.player = AVPlayer.init(url: url!)
    }
    
    
    
    
    func stop(){
        
    }
    
    func setOnForward(onForward:OnForwar){
        self.onForward = onForward
    }
    
    func setOnBackward(onBackward:OnBackward){
        self.onBackward = onBackward
    }
    
    func setRadiosList(listRadios:[RadioModel]){
        self.listRadios = listRadios
    }
    
    func setCurrentModelIndex(currentModelIndex:Int){
        self.currentModelIndex = currentModelIndex
    }
}

protocol OnForwar{
    func onForward(data:AnyObject);
}

protocol OnBackward{
    func onBackward(data:AnyObject);
}
