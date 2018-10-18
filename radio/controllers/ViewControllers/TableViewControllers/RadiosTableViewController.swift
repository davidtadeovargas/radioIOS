//
//  RadiosTableViewController.swift
//  radio
//
//  Created by MacBook 13 on 8/7/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit


class RadiosTableViewController: CustomTableViewController,RadiosResponseProtocol {
    
    /*
     Contains the object model radio for radio consume pagin control
     */
    static var listRadios:ListRadios = ListRadios()
    
    /*
        Temoral list for favorites
     */
    var listFavoriteRadios:ListRadios = ListRadios()
    
    /*
     Temoral list for search
     */
    var listSearchRadios:ListRadios = ListRadios()
    
    /*
        Flag to show only favorites
     */
    private var showOnlyFavorites:Bool = false
    
    /*
        Handler for the same table, when favorite is unselected from favorite tabs, it should
        delete update it in the featured tab
     */
    private var radiosTableViewController:RadiosTableViewController? = nil
    
    /*
        Contains the query for the server
     */
    private var query:String = ""
    
    /*
        Listener for cell events
     */
    private var onCellTouch:OnCellTouch! = nil
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        self.tableView.separatorStyle = .none //Remove line separatos
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        /*
            Get the first records from the server, only for features
         */
        if(!self.showOnlyFavorites){
            updateWithServer()
        }
        
        
    }

    
    /*
     Update the table with the server with cache
     */
    func updateWithServer(){
        
        /*
            Send to controller befor server connection
         */
        if(tableProtocol != nil){
            tableProtocol?.beforeServerConnection()
        }
        
        do {
            
            /*
                Determines the list count
             */
            var actualCount:Int = 0
            if(self.showOnlyFavorites){
                actualCount = listFavoriteRadios.listRadios.count
            }
            else if(!self.query.isEmpty){
                actualCount = listSearchRadios.listRadios.count
            }
            else{
                actualCount = RadiosTableViewController.listRadios.listRadios.count
            }
            
            /*
             Consume the webservice with cache
             */
            let radiosListNetController:RadiosListNetController = RadiosListNetController()
            radiosListNetController.onResponseProtocol = self
            radiosListNetController.onError = self //Error handler for connection
            radiosListNetController.initURL(offset: actualCount, limit: 10, query: query)
            print(query)
            try radiosListNetController.task()
            
        } catch {
            
            /*
             Print error to console
             */
            print(error)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /*
        Return the number of rows to show in the table
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(RadiosTableViewController.listRadios.listRadios != nil){
            
            /*
             When there are rows this event can fire
             */
            if(RadiosTableViewController.listRadios.listRadios.count > 0){
                if(onInitialRows != nil){
                    onInitialRows?.onInitialRows()
                }
            }
            
            /*
             If the tab is on features it should show favorites with radios but if
             tab is on favorites only has to show favorites
             */
            if(self.showOnlyFavorites){
                listFavoriteRadios.listRadios = [] //Clear the temporal list
                var favoritesCount:Int = 0
                for radio in RadiosTableViewController.listRadios.listRadios{
                    if(radio.hearthIt){
                        listFavoriteRadios.listRadios.append(radio)
                        favoritesCount = favoritesCount + 1
                    }
                }
                
                if(favoritesCount == 0){
                    
                    /*
                     When there are no rows this event can fire
                     */
                    if(onInitialEmptyRows != nil){
                        onInitialEmptyRows?.onInitialEmptyRows()
                    }
                }
                
                return favoritesCount
            }
            else if(!self.query.isEmpty){ //Search row size
                
                let count:Int = listSearchRadios.listRadios.count
                if(count == 0){
                    
                    /*
                     When there are no rows this event can fire
                     */
                    if(onInitialEmptyRows != nil){
                        onInitialEmptyRows?.onInitialEmptyRows()
                    }
                }
                else{
                    
                    /*
                     When there are rows this event fire
                     */
                    if(onRows != nil){
                        onRows?.onRows()
                    }
                }
                
                return listSearchRadios.listRadios.count
            }
            else{
                return RadiosTableViewController.listRadios.listRadios.count
            }
        }
        else{
            return 0
        }
    }
    
    
    /*
     Error handling for protocol connections
     */
    override func onError(error: AnyObject) {
        
        /*
         Just deliver the response, we dont have to control this phase
         */
        self.responseTableConnection.onError(error: error)
    }
    /*
     Implementation protocol
     */
    func onLoadFinish() {
        
    }
    /*
     Implementation response radios protocol
     */
    func result(data: [RadioModel]) {
        
        /*
            If there are no more data to scroll so set the flag
         */
        if(data.count==0){
            continueScrolling = false
        }
        
        /*
            If comes from search
         */
        if(!query.isEmpty){
            listSearchRadios.listRadios =  data as [RadioModel]
        }
        else{
            
            /*
             If the list already contains data so add the next items to it
             */
            if(RadiosTableViewController.listRadios.listRadios != nil){
                
                let lista_:[RadioModel] = data as [RadioModel] //Set the array of results
                for item in lista_ {
                    RadiosTableViewController.listRadios.listRadios.append(item)
                }
            }
                /*
                 The list is empty so equals to the list of result
                 */
            else{
                RadiosTableViewController.listRadios.listRadios = data as [RadioModel] //Set the array of results
            }
        }
        
        /*
         Reload table
         */
        reloadTable()
        
        /*
         Anounce to the controller the end of the comunication with the server
         */
        self.responseTableConnection.onEndResponse()
    }
    
    
    
    /*
        Reload data table
     */
    func reloadTable(){
       
        DispatchQueue.main.async {
            
            /*
             Reload table
             */
            self.tableView.reloadData()
        }
    }
    
    /*
        Listener when the cell is selected
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var radioList_:[RadioModel]? = nil
        
        /*
         Get the radio model depend from favorite temporal or from featured model
         */
        let row:Int = indexPath.row
        var radioModel:RadioModel? = nil
        if(self.showOnlyFavorites){ //Take the model from favorites radios
            radioModel = listFavoriteRadios.listRadios[row]
            radioList_ = listFavoriteRadios.listRadios
        }
        else if(!self.query.isEmpty){ //Take the model from the search
            radioModel = listSearchRadios.listRadios[row]
            radioList_ = listSearchRadios.listRadios
        }
        else{ //Take the model from normal radios
            radioModel = RadiosTableViewController.listRadios.listRadios![row]
            radioList_ = RadiosTableViewController.listRadios.listRadios
        }
        
        /*
            Deliver the radio model on cell touch
         */
        if(self.onCellTouch != nil){
            self.onCellTouch.onCellTouch(radioModel: radioModel!,currentModelIndex: indexPath.row, listRadios: radioList_!)
        }
    }
    
    
    /*
        Render the rows of the table
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get the current cell
        let cell_:RadiosTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "RadiosTableViewCell", for:indexPath) as! RadiosTableViewCell
        
        /*
         Set the local row
         */
        let row:Int = indexPath.row
        
        /*
         Get the radio model depend from favorite temporal or from featured model
         */
        var radioModel:RadioModel? = nil
        if(self.showOnlyFavorites){ //Take the model from favorites radios
            radioModel = listFavoriteRadios.listRadios[row]
        }
        else if(!self.query.isEmpty){ //Take the model from the search
            radioModel = listSearchRadios.listRadios[row]
        }
        else{ //Take the model from normal radios
            radioModel = RadiosTableViewController.listRadios.listRadios![row]
        }
        
        /*
            Add the radio model to the cell
         */
        cell_.radioModel = radioModel
        
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
                            
                            let image:UIImage = UIImage(data: imageData as Data)!
                            cell_.radioImageView.image = image
                        }
                    }
                }
                
            } catch _ {
            }
        }
        
        /*
            Set the tittle and subtittle
         */
        cell_.tittleLabel.text = radioModel?.name
        cell_.subtitleLabel.text = radioModel?.sourceRadio
        
        /*
            Set the row in the image to get it on control
         */
        cell_.hearthImageView.tag = row
        
        /*
            Paint or not paint the heart icon
         */
        var imageHeart = "hearth-empty"
        if(radioModel?.hearthIt)!{
            imageHeart = "hearth-red"
        }
        let image = UIImage(named: imageHeart)
        cell_.hearthImageView.image = image
        
        /*
         Event clic for the heart icon
         */
        if(cell_.hearthImageView.gestureRecognizers?.count == nil){
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(heartTapped(tapGestureRecognizer:)))
            cell_.hearthImageView?.isUserInteractionEnabled = true
            cell_.hearthImageView?.tag = row
            cell_.hearthImageView?.addGestureRecognizer(tapGestureRecognizer)
        }
        
        /*
            If the tab is on features it should show favorites with radios but if
            tab is on favorites only has to show favorites
         */
        if(self.showOnlyFavorites){
            if(!(radioModel?.hearthIt)!){
                cell_.isHidden = true
            }
        }
        else{
            cell_.isHidden = false
        }
        
        return cell_
    }
    
    
    
    /*
        When the user clics on the heart icon
     */
    @objc func heartTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let tappedImage:UIImageView = tapGestureRecognizer.view as! UIImageView
        
        /*
            Get the row from the image clicked
         */
        let row:Int = tappedImage.tag
        
        /*
         Get the radio model
         */
        var radioModel:RadioModel = RadiosTableViewController.listRadios.listRadios[row]
        if(showOnlyFavorites){
           radioModel = listFavoriteRadios.listRadios[row]
        }
        
        /*
            Paint and validate the color of the heart
         */
        var imageHeart = ""
        if(!radioModel.hearthIt){
            
            radioModel.hearthIt = true
            imageHeart = "hearth-red"
            
            /*
             Set the true value with the server for this favorite
             */
            FavoritesSettings.shared.updateFavorite(id: radioModel.id as! Int,val: true)
            
            /*
                Update the radio original list caused by favorites hearth selection
             */
            if(showOnlyFavorites){
                for model_ in RadiosTableViewController.listRadios.listRadios {
                    if(model_.id == radioModel.id){
                       model_.hearthIt = true
                        break
                    }
                }
            }
        }
        else{
            radioModel.hearthIt = false
            imageHeart = "hearth-empty"
            
            /*
             Set the false value with the server for this favorite
             */
            FavoritesSettings.shared.updateFavorite(id: radioModel.id as! Int,val: false)
            
            /*
             Update the radio original list caused by favorites hearth selection
             */
            if(showOnlyFavorites){
                for model_ in RadiosTableViewController.listRadios.listRadios {
                    if(model_.id == radioModel.id){
                        model_.hearthIt = false
                        break
                    }
                }
            }
        }
        let image = UIImage(named: imageHeart)
        tappedImage.image = image
        
        /*
            If it is favorites reload the table
         */
        if(self.showOnlyFavorites){
            self.reloadTable()
        }
    }
    
    
    /*
        Detect when scroll arrives to end
     */
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*
            If comes from search
         */
        if(query.isEmpty){
            
            let  height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            if distanceFromBottom < height {
                
                /*
                 If it has to continue scrolling
                 */
                if(continueScrolling){
                    
                    /*
                     Deliver response to controller
                     */
                    if(tableProtocol != nil){
                        tableProtocol?.onScrollEnd()
                    }
                    
                    /*
                     The limit of the tabla has been reached so get more data from the web server
                     */
                    updateWithServer()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /*
         Set the heigth of the table based on screen dimentions of device
         */
        
        //Get the screen dimentions
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
         
         return CGFloat(180)
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
        
        return CGFloat(90)
    }
    
    
    func setRadiosTableViewController(radiosTableViewController:RadiosTableViewController){
        self.radiosTableViewController = radiosTableViewController
    }
    func setShowOnlyFavorites(val:Bool){
        self.showOnlyFavorites = val
    }
    func setQuery(query:String){
        self.query = query
    }
    func setOnCellTouch(onCellTouch:OnCellTouch){
        self.onCellTouch = onCellTouch
    }
}


/*
    Protocol to handle cell touch events
 */
protocol OnCellTouch{
    func onCellTouch(radioModel:RadioModel,currentModelIndex:Int,listRadios:[RadioModel])
}
