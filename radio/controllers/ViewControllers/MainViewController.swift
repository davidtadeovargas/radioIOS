//
//  MainViewController.swift
//  radio
//
//  Created by MacBook 13 on 7/3/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit
import SwiftHTTP
import ContextMenu
import GoogleMobileAds
import HGCircularSlider


class MainViewController: UIViewController, GADBannerViewDelegate, ResponseTableConnection,TableProtocol,UISearchBarDelegate,UISearchDisplayDelegate,AdmobProtocol,RowSelection {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var recentTextField: UITextField!
    @IBOutlet weak var yourGenresTextField: UITextField!
    @IBOutlet weak var favoriteTextField: UITextField!
    @IBOutlet weak var yourThemesTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var sleepBackgroundView: UIView!
    @IBOutlet weak var featuredButton: UIButton!
    @IBOutlet weak var genresButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var themesButton: UIButton!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sleepView: CircularSlider!
    
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var buttonStackH: NSLayoutConstraint!
    
    @IBOutlet weak var imageviewLoading: UIImageView!
    @IBOutlet weak var tittle: UITextField!
    @IBOutlet weak var centralLabel: UILabel!
    @IBOutlet weak var miniplayer: MiniPlayerView!
    
    /*
        Actual heigth of the button stack
     */
    var currentHeigthButtonStack:Double = 0
    
    /*
        The gradient of the window is needed locally to be updated
     */
    var gradientViewController = CAGradientLayer()
    
    var interstitial: GADInterstitial! //Contains the interseptial of this window
    
    var searchBarIsVisible = false
    var featuredSection:Bool = false
    var genresSection:Bool = false
    var favoriteSection:Bool = false
    var themesSection:Bool = false
    
    /*
        Flags to check when each section is working
     */
    var featuredTurn:Bool = false
    var genresTurn:Bool = false
    var themesTurn:Bool = false
    var favoritesTurn:Bool = false
    var searchTurn:Bool = false
    
    /*
        Contains the radios table view controller for radios and favorites
     */
    var radiosTableViewController:RadiosTableViewController? = nil
    
    /*
     Contains the radios table view controller only for favorites radios
     */
    var radiosFavoritesTableViewController:RadiosTableViewController? = nil
    
    /*
     Contains the radios table view controller only for searched radios
     */
    var radiosSearchTableViewController:RadiosTableViewController? = nil
    
    /*
     Contains the themes table view controller
     */
    var themesTableViewController:ThemesTableViewController? = nil
    
    /*
        Contains the sleep window
     */
    var sleepViewWindow:SleepView? = nil
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
            Banner
         */
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        /*
            This is the events delegate
         */
        self.searchBar.delegate = self
        
        let smart = kGADAdSizeSmartBannerPortrait
        let banner = GADBannerView(adSize: smart)
        banner.frame.origin = CGPoint(x: 0, y: screenHeight - 50) // set your own offset
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // insert your own unit ID
        banner.rootViewController = self
        self.view.addSubview(banner)
        let request = GADRequest()
        banner.load(request)
        
        /*
            The mini radio should not show for init
         */
        miniplayer.isHidden = true
        
        /*
         Transparent background in searchbar
         */
        //searchBar.barTintColor = UIColor.clear
        //searchBar.backgroundColor = UIColor.clear
        //searchBar.isTranslucent = true
        let image = UIImage()
        searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        searchBar.scopeBarBackgroundImage = image
        
        /*
        Hide the textfields bar colors not occupied
         */
        yourGenresTextField.isHidden = true
        favoriteTextField.isHidden = true
        yourThemesTextField.isHidden = true
        
        /*
            Initially search bar is hidden
         */
        searchBar.isHidden = true
        
        /*
            Change search bar size font in no normal way
         */
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        //textFieldInsideUISearchBar?.textColor = UIColor.red
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(11)
        
        /*
         Load the gif image
         */
        imageviewLoading.loadGif(name: "circular_loading")
        
        imageviewLoading.isHidden = true //Initially hidden
        
        /*
            Initially the content view of subviews will not be visible
         */
        self.hideContentView()
        
        /*
         Get the actual settings and paint the splash screen acording
         and paint the view controller with the local gradient
         */
        ThemeSettingsManager.shared.painViewControllerAdd(uiViewController: self,gradientLeft: gradientViewController)
        
        /*
         Load the featured table view controller
         */
        self.loadFeatured()
        
        
    }
    
    
    func onRowSelection(genre: GenreModel) {
        
        /*
         Load the search table view controller
         */
        radiosSearchTableViewController = storyboard!.instantiateViewController(withIdentifier: "RadiosTableViewController") as! RadiosTableViewController
        RadiosTableViewController.listSearchRadios.setListRadios(listRadios: [])
        radiosSearchTableViewController?.setGenre(genre: genre)
        radiosSearchTableViewController?.tableProtocol = self //Methods to table
        radiosSearchTableViewController?.responseTableConnection = self //Connect the success or error of the web server connection
        radiosSearchTableViewController?.view.translatesAutoresizingMaskIntoConstraints = true
        radiosSearchTableViewController?.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        addChildViewController(radiosSearchTableViewController!)
        containerView.addSubview((radiosSearchTableViewController?.view)!)
        radiosSearchTableViewController?.didMove(toParentViewController: self)
        
        let onCellTouch:OnCellTouch = getInstanceCellTouch()
        radiosSearchTableViewController?.setOnCellTouch(onCellTouch: onCellTouch)
    }
    
    
    
    /*
        When user tries to search for radios
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        /*
            If there is nothing to search dont continue
         */
        let textToSearch:String = (self.searchBar.text)!
        if(textToSearch.isEmpty){
            return;
        }
        
        /*
            Search the ocurrencies
         */
        search()
    }
    
    
    func loadFeatured(){
        
        self.featuredTurn = true
        
        /*
         Control all related to this section
         */
        self.sectionEvent()
    }
    
    
    /*
        Evento para busqueda
     */
    func search(){
        
        self.searchTurn = true
        
        /*
            Always Hide the central label in case it has radios
         */
        self.centralLabel.isHidden = true
        
        /*
         Control all related to this section
         */
        self.sectionEvent()
    }
    
    /*
        This event detects when table scroll is at end
     */
    func onScrollEnd() {
        
        DispatchQueue.main.async {
            
            /*
             Show the loading icon
             */
            self.imageviewLoading.isHidden = false
        }
    }

    /*
        From table protocol and before server connnection
     */
    func beforeServerConnection() {
        
        DispatchQueue.main.async {
            
            /*
             Show the loading icon
             */
            self.imageviewLoading.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func hideContentView(){
        self.containerView.isHidden = true
    }
    func showContentView(){
        self.containerView.isHidden = false
    }
    
    /*
     End of overriden methods
     */
    
    private func hideAllBarTextFields(){
        /*
         Hide all bar text fields, this happens when user
         any of the window menus
         */
        recentTextField.isHidden = true
        yourGenresTextField.isHidden = true
        favoriteTextField.isHidden = true
        yourThemesTextField.isHidden = true
    }
    private func showFeaturedBarTextField(){ //User touched recent menu
        
        self.hideAllBarTextFields() //Hide all other sections fields
        
        recentTextField.isHidden = false //Show this section
        
        self.disableAllFlags() //Disable all sections flags
        
        self.featuredTurn = true //Activate this flag
    }
    private func showYourGenresBarTextField(){ //User touched your genres menu
        
        self.hideAllBarTextFields() //Hide all other sections fields
        
        yourGenresTextField.isHidden = false //Show this section
        
        self.disableAllFlags() //Disable all sections flags
        
        self.genresTurn = true //Activate this flag
    }
    private func showFavoriteBarTextField(){ //User touched your favorite menu
        
        self.hideAllBarTextFields() //Hide all other sections fields
        
        favoriteTextField.isHidden = false //Show this section
        
        self.disableAllFlags() //Disable all sections flags
        
        self.favoritesTurn = true //To show only favorites
    }
    private func showYourThemesBarTextField(){ //User touched your themes menu
        
        self.hideAllBarTextFields() //Hide all other sections fields
        
        yourThemesTextField.isHidden = false //Show this section
        
        self.disableAllFlags() //Disable all sections flags
        
        self.themesTurn = true //Activate this flag
    }
    
    func interstitialWillDismissScreen() {
    }
    
    
    
    func getInstanceCellTouch() -> OnCellTouch{
        
        /*
         This class is to control the cell radio touch events to show or hide mini player
         */
        class OnCellTouch_: OnCellTouch {
            
            private var miniPlayer_:MiniPlayerView! = nil
            private var viewController:UIViewController! = nil
            
            private var currentModelIndex:Int! = nil
            
            static var sharedInstance = OnCellTouch_()
            
            private var counterAdd:Int = 0
            
            private init() { }
            
            
            
            
            func onCellTouch(radioModel: RadioModel,currentModelIndex:Int,listRadios:[RadioModel]) {
                
                counterAdd = counterAdd + 1
                
                if(self.counterAdd==3){
                    counterAdd = 0
                    
                    /*
                     Show the interseptial of the window
                     */
                    currentVc = viewController
                    admobDelegate.currentVc = currentVc
                    admobDelegate.admobProtocol = viewController as! AdmobProtocol
                    admobDelegate.showAd()
                }
                
                /*
                 Show the mini player
                 */
                miniPlayer_.isHidden = false
                
                /*
                 Set the link streaming radio
                 */
                miniPlayer_.setURLMusic(radioModel: radioModel)
                
                /*
                 Set the list of songs
                 */
                miniPlayer_.setCurrentModelIndex(currentModelIndex: currentModelIndex)
                
                /*
                 Set the current list radios
                 */
                miniPlayer_.setRadiosList(listRadios: listRadios)
                
                /*
                 Set the current existing view controller
                 */
                miniPlayer_.setViewController(viewController:  self.viewController)
                
                /*
                 Reload image
                 */
                miniPlayer_.updateImage()
                
                /*
                 Play the new station
                 */
                miniPlayer_.play()
            }
            
            
            func newObject() -> OnCellTouch_{
                OnCellTouch_.sharedInstance = OnCellTouch_()
                return .sharedInstance
            }
            
            func setViewController(viewController:UIViewController){
                self.viewController = viewController
            }
            func setMiniPlayer(miniPlayer_:MiniPlayerView){
                self.miniPlayer_ = miniPlayer_
            }
            func setCurrentModelIndex(currentModelIndex:Int){
                self.currentModelIndex = currentModelIndex
            }
        }
        let onCellTouch:OnCellTouch_ = OnCellTouch_.sharedInstance.newObject()
        onCellTouch.setMiniPlayer(miniPlayer_: miniplayer)
        onCellTouch.setViewController(viewController: self)
        return onCellTouch
    }
    
    /*
        Control the sections
    */
    func sectionEvent(){
        
        /*
         Always Hide the central label
         */
        self.centralLabel.isHidden = true
        
        
        let onCellTouch:OnCellTouch = getInstanceCellTouch()
        
        /*
         Search clicked
         */
        if(self.searchTurn){
            
            /*
                Hide the button stack view to simulate search
             */
            buttonStack.isHidden = true
            if(buttonStackH.constant != 0){
                currentHeigthButtonStack = Double(buttonStackH.constant)
                buttonStackH.constant = 0
            }
            
            /*
             Load the search table view controller
             */
            radiosSearchTableViewController = storyboard!.instantiateViewController(withIdentifier: "RadiosTableViewController") as! RadiosTableViewController
            let query:String = self.searchBar.text!
            print(query)
            radiosSearchTableViewController?.setQuery(query: query)
            radiosSearchTableViewController?.tableProtocol = self //Methods to table
            radiosSearchTableViewController?.responseTableConnection = self //Connect the success or error of the web server connection
            radiosSearchTableViewController?.view.translatesAutoresizingMaskIntoConstraints = true
            
            class OInitialEmptyRows: OnInitialEmptyRows {
                var centralLabel: UILabel!
                func onInitialEmptyRows() {
                    self.centralLabel.isHidden = false
                }
            }
            let onInitialEmptyRows:OInitialEmptyRows = OInitialEmptyRows()
            onInitialEmptyRows.centralLabel = self.centralLabel
            class OnRows_: OnRows {
                var centralLabel: UILabel!
                func onRows() {
                    self.centralLabel.isHidden = true
                }
            }
            let onRows:OnRows_ = OnRows_()
            onRows.centralLabel = self.centralLabel
            
            radiosSearchTableViewController?.onInitialEmptyRows = onInitialEmptyRows
            radiosSearchTableViewController?.onRows = onRows //When there are rows
            
            radiosSearchTableViewController?.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            addChildViewController(radiosSearchTableViewController!)
            containerView.addSubview((radiosSearchTableViewController?.view)!)
            radiosSearchTableViewController?.didMove(toParentViewController: self)
            radiosSearchTableViewController?.setOnCellTouch(onCellTouch: onCellTouch) //Listener for cell touch
            
            /*
                Hide the keyboard
             */
            self.searchBar.endEditing(true)
        }
        else if(self.genresTurn){
            
            DispatchQueue.main.async {
                
                /*
                 Show the loading icon
                 */
                self.imageviewLoading.isHidden = false
            }
            
            /*
             Load the genres table view controller
             */
            let controller:GenresTableViewController = storyboard!.instantiateViewController(withIdentifier: "GenresTableViewController") as! GenresTableViewController
            addChildViewController(controller)
            controller.responseTableConnection = self //Connect the success or error of the web server connection
            controller.view.translatesAutoresizingMaskIntoConstraints = true
            controller.setRowSelection(rowSelection: self)
            controller.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            containerView.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
        else if(self.themesTurn){
            
            /*
             Load the genres table view controller
             */
            if(themesTableViewController == nil){
                themesTableViewController = storyboard!.instantiateViewController(withIdentifier: "ThemesTableViewController") as! ThemesTableViewController
                themesTableViewController?.tableProtocol = self //Methods to table
                themesTableViewController?.uiViewController = self
                themesTableViewController?.responseTableConnection = self //Connect the success or error of the web server connection
                themesTableViewController?.view.translatesAutoresizingMaskIntoConstraints = true
                themesTableViewController?.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
                themesTableViewController?.setMiniPlayer(miniPlayer: miniplayer)
            }
            addChildViewController(themesTableViewController!)
            containerView.addSubview((themesTableViewController?.view)!)
            themesTableViewController?.didMove(toParentViewController: self)
        }
        else if(self.featuredTurn){
            
            /*
             Load the featured table view controller
             */
            if(radiosTableViewController == nil){
                radiosTableViewController = storyboard!.instantiateViewController(withIdentifier: "RadiosTableViewController") as! RadiosTableViewController
                radiosTableViewController?.tableProtocol = self //Methods to table
                radiosTableViewController?.responseTableConnection = self //Connect the success or error of the web server connection
                radiosTableViewController?.view.translatesAutoresizingMaskIntoConstraints = true
                radiosTableViewController?.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
            }
            radiosTableViewController?.setShowOnlyFavorites(val: false) //Show or not only favorites
            addChildViewController(radiosTableViewController!)
            containerView.addSubview((radiosTableViewController?.view)!)
            radiosTableViewController?.reloadTable()
            radiosTableViewController?.didMove(toParentViewController: self)
            radiosTableViewController?.setOnCellTouch(onCellTouch: onCellTouch) //Listener for cell touch
        }
        else if(self.favoritesTurn){
            
            /*
             Load the favorite table view controller
             */
            if(radiosFavoritesTableViewController == nil){
                radiosFavoritesTableViewController = storyboard!.instantiateViewController(withIdentifier: "RadiosTableViewController") as! RadiosTableViewController
                radiosFavoritesTableViewController?.tableProtocol = self //Methods to table
                radiosFavoritesTableViewController?.responseTableConnection = self //Connect the success or error of the web server connection
                radiosFavoritesTableViewController?.view.translatesAutoresizingMaskIntoConstraints = true
                radiosFavoritesTableViewController?.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
                class OInitialEmptyRows: OnInitialEmptyRows {
                    var centralLabel: UILabel!
                    func onInitialEmptyRows() {
                        self.centralLabel.isHidden = false
                    }
                }
                let onInitialEmptyRows:OInitialEmptyRows = OInitialEmptyRows()
                onInitialEmptyRows.centralLabel = self.centralLabel
                radiosFavoritesTableViewController?.onInitialEmptyRows = onInitialEmptyRows
                radiosFavoritesTableViewController?.setRadiosTableViewController(radiosTableViewController: self.radiosFavoritesTableViewController!)
            }
            radiosFavoritesTableViewController?.setShowOnlyFavorites(val: true) //Show or not only favorites
            addChildViewController(radiosFavoritesTableViewController!)
            containerView.addSubview((radiosFavoritesTableViewController?.view)!)
            radiosFavoritesTableViewController?.didMove(toParentViewController: self)
            radiosFavoritesTableViewController?.reloadTable() //Reload the table
            radiosFavoritesTableViewController?.setOnCellTouch(onCellTouch: onCellTouch) //Listener for cell touch
        }
    }
    
    func disableAllFlags(){
        
        self.featuredTurn = false
        self.genresTurn = false
        self.favoritesTurn = false
        self.themesTurn = false
        self.searchTurn = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*
         Get the actual settings and paint the splash screen acording
         and paint the view controller with gradient
         */
        //ThemeSettingsManager.shared.painViewController(uiViewController: self)
        
    }
    
    
    func render(){
        
        /*
         Set the size of the table for test porpouse only
         */
        
        //Get the screen widht
        /*let screenSize: CGRect = UIScreen.main.bounds
         let screenWidth = screenSize.width
         let screenHeight = screenSize.height
         
         //Iphone 4s, Iphone 5, Iphone 5s, Iphone SE
         if(screenWidth==320){
         
         //Iphone 5, 5s
         if(screenHeight==568){
         }
         }
         //Iphone 6, Iphone 6s, Iphone X
         else if(screenWidth==375){
         
         //Iphone X
         if(screenHeight==812){
         }
         //Iphone 6, Iphone 6s
         else{
         }
         }
         //Iphone 6s plus, Iphone 6s plus, Iphone 7, Iphone 7 plus, Iphone 8, Iphone 8 Plus
         else if(screenWidth==414){
         
         self.frame = CGRect(x: 0, y: 100, width: 300, height: 400)
         }
         //Ipad 2, Ipad Air, Ipad Air 2, Ipad retina, Ipad 5th generation, ipad pro 9.7
         else if(screenWidth==768){
         }
         //Ipad PRO 10.5
         else if(screenWidth==834){
         }
         //Ipad Pro 12.9
         else if(screenWidth==1024){
         }*/
    }
    
    
    
    
    func renderViews(){
        
        //Get the screen widht
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        print(screenWidth)
        
        //Iphone 4s, Iphone 5, Iphone 5s, Iphone SE
        if(screenWidth==320){
            
            //Iphone 5, 5s
            if(screenHeight==568){
            }
        }
            //Iphone 6, Iphone 6s, Iphone X
        else if(screenWidth==375){
            
            //Iphone X
            if(screenHeight==812){
            }
                //Iphone 6, Iphone 6s
            else{
            }
        }
            //Iphone 6s plus, Iphone 6s plus, Iphone 7, Iphone 7 plus, Iphone 8, Iphone 8 Plus
        else if(screenWidth==414){
        }
            //Ipad 2, Ipad Air, Ipad Air 2, Ipad retina, Ipad 5th generation, ipad pro 9.7
        else if(screenWidth==768){
        }
            //Ipad PRO 10.5
        else if(screenWidth==834){
        }
            //Ipad Pro 12.9
        else if(screenWidth==1024){
        }
    }
    
    
    
    func updateGradient(){
        
        /*
            Read the theme app and update it
         */
        ThemeSettingsManager.shared.painViewControllerUpdate(uiViewController: self, gradientLeft: gradientViewController)
    }
    
    
    @IBAction func sleepTouch(_ sender: UIButton) {
        
        /*
            Show the sleep window
         */
        if(sleepViewWindow == nil){
            sleepViewWindow = SleepView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            sleepViewWindow?.uiViewController = self
            self.view.addSubview(sleepViewWindow!)
            self.view.bringSubview(toFront: sleepViewWindow!)
        }
        else{
            sleepViewWindow?.isHidden = false
        }
    }
    @IBAction func featuredTouch(_ sender: UIButton) {
        
        self.showFeaturedBarTextField() //Validation when genres is touched
        
        /*
         Control all related to this section
         */
        self.sectionEvent()
    }
    @IBAction func yourGenresTouch(_ sender: UIButton) {
        
        self.showYourGenresBarTextField() //Validation when genres is touched
        
        /*
            Control all related to this section
         */
        self.sectionEvent()
    }
    @IBAction func favoriteTouch(_ sender: UIButton) {
        
        self.showFavoriteBarTextField() //Validation when genres is touched
        
        /*
         Control all related to this section
         */
        self.sectionEvent()
    }
    @IBAction func yourThemesTouch(_ sender: UIButton) {
        
        self.showYourThemesBarTextField() //Validation when genres is touched
        
        /*
         Control all related to this section
         */
        self.sectionEvent()
    }
    @IBAction func menuTouch(_ sender: UIButton) {
        
        /*
            Save parameters
         */
        Parameters.sharedInstance.UIViewController = self
        
        /*
            Show the context menu
         */
        ContextMenu.shared.show(
            sourceViewController: self,
            viewController: MenuViewController()
        )
    }
    @IBAction func searchTouch(_ sender: UIButton) {
        
        /*
            Show or hide the search bar
         */
        if(searchBarIsVisible==false){
            
            /*
             Show the search bar
             */
            self.searchBar.isHidden = false
            
            /*
                Hide tittle text
             */
            self.tittle.isHidden = true
            
            /*
             Change the background image
             */
            self.searchButton.setImage(UIImage(named: "forward_arrow.png")!, for: .normal)
            
            /*
             Reset flag
             */
            self.searchBarIsVisible = true
        }
        else{
            
            /*
             Show the button stack view normal size
             */
            if(currentHeigthButtonStack>0){
                buttonStack.isHidden = false
                buttonStackH.constant = CGFloat(currentHeigthButtonStack)
            }
            
            /*
             Hide the search bar
             */
            self.searchBar.isHidden = true
            
            /*
             Show tittle text
             */
            self.tittle.isHidden = false
            
            /*
             Change the background image
             */
            self.searchButton.setImage(UIImage(named: "search.png")!, for: .normal)
            
            //Hide keyboard
            self.view.endEditing(true)
            
            /*
             Clear the search field
             */
            self.searchBar.text = ""
            
            /*
                Show the previus controller
             */
            if(featuredTurn){
                self.featuredButton.sendActions(for: .touchUpInside)
            }
            else if(genresTurn){
                self.genresButton.sendActions(for: .touchUpInside)
            }
            else if(themesTurn){
                self.themesButton.sendActions(for: .touchUpInside)
            }
            else if(favoritesTurn){
               self.favoriteButton.sendActions(for: .touchUpInside)
            }
            
            /*
             Reset flag
             */
            self.searchBarIsVisible = false
        }
    }
    /*
        End of touch events
     */
    
    
    
    
    /*
     GenresTableErrorConnection
     */
    func onError(error: AnyObject) {
        
        /*
         Hide the genres table
         */
        /*DispatchQueue.main.async {
            self.genresTable.isHidden = true
        }*/
        
        /*
         Show error
         */
        //let dialog:Dialog = Dialog(uiViewController: self,message: error.localizedDescription)
        //dialog.showOK()
    }
    func onEndResponse() { //When the connection from the table has finished
        
        DispatchQueue.main.async {
        
            /*
             Show the content view of subviews
             */
            self.showContentView()
            
            /*
             Hide the loading icon
             */
            self.imageviewLoading.isHidden = true
        }
    }
}
