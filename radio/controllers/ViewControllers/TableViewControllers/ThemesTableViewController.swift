//
//  GenresTableViewController.swift
//  radio
//
//  Created by MacBook 13 on 8/6/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit

class ThemesTableViewController: CustomTableViewController,ThemesResponseProtocol {
    
    /*
     Contains the object model themes for radio consume pagin control
     */
    var listThemes:ListThemes = ListThemes()
    
    /*
        Contains the parent view controller
    */
    var uiViewController:MainViewController!
    
    /*
        Contains the object for the mini player
     */
    private var miniPlayer:MiniPlayerView! = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.separatorStyle = .none //Remove line separatos
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        updateWithServer()
    }
    
    
    /*
        Update the table with the server by filters
     */
    func updateWithServer(){
        
        do {
            
            /*
             Send to controller befor server connection
             */
            if(tableProtocol != nil){
                tableProtocol?.beforeServerConnection()
            }
            
            /*
             Consume the webservice
             */
            let themesListNetController:ThemesListNetController = ThemesListNetController()
            themesListNetController.onResponseProtocol = self
            themesListNetController.onError = self //Error handler for connection
            themesListNetController.initURL(offset: self.listThemes.listThemes.count, limit: 10)
            try themesListNetController.task()
            
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.listThemes.listThemes != nil){
            return self.listThemes.listThemes.count / 2
        }
        else{
            return 0
        }
    }
    
    
    func setMiniPlayer(miniPlayer:MiniPlayerView){
        self.miniPlayer = miniPlayer
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
     Implementation response genres protocol
     */
    func result(data: [ThemeModel]) {
        
        /*
         If there are no more data to scroll so set the flag
         */
        if(data.count==0){
            continueScrolling = false
        }
        
        /*
         If the list already contains data so add the next items to it
         */
        if(self.listThemes.listThemes != nil){
            
            let lista_:[ThemeModel] = data as [ThemeModel] //Set the array of results
            for item in lista_ {
                self.listThemes.listThemes.append(item)
            }
        }
        /*
         The list is empty so equals to the list of result
         */
        else{
            self.listThemes.listThemes = data as [ThemeModel] //Set the array of results
        }
        
        DispatchQueue.main.async {
            
            /*
             Reload table
             */
            self.tableView.reloadData()
        }
        
        /*
         Anounce to the controller the end of the comunication with the server
         */
        self.responseTableConnection.onEndResponse()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get the current cell
        let cell_:ThemesViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ThemesViewCell", for:indexPath) as! ThemesViewCell
        
        /*
         Set the local row
         */
        var row:Int = indexPath.row
        
        row = row + row
        
        /*
         Get the left genre model
         */
        let themeLeft:ThemeModel = listThemes.listThemes![row]
        
        /*
         Set the left view gradient
         */
        let gradientLeft = CAGradientLayer()
        gradientLeft.frame = cell_.leftView.bounds
        gradientLeft.colors = [ColorsUtility.hexStringToUIColor(hex: themeLeft.grad_start_color!).cgColor,ColorsUtility.hexStringToUIColor(hex: themeLeft.grad_end_color!).cgColor]
        gradientLeft.locations = [0.0, 1.0]
        cell_.leftView.layer.insertSublayer(gradientLeft, at: 0)
        
        /*
         Set the left text
         */
        cell_.labelLeft.text = themeLeft.name
        
        /*
         Event clic for the left theme icon
         */
        if(cell_.leftView.gestureRecognizers?.count == nil){
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(tapGestureRecognizer:)))
            cell_.leftView?.isUserInteractionEnabled = true
            cell_.leftView?.tag = row
            cell_.leftView?.addGestureRecognizer(tapGestureRecognizer)
        }
        
        row = row + 1 //Add one to go for the rigth value
        
        /*
         If should paint the rigth view icon
         */
        if(row < self.listThemes.listThemes.count){
            
            /*
             Get the left genre model
             */
            let themeRigth:ThemeModel = listThemes.listThemes![row]
            
            /*
             Set the left view gradient
             */
            let gradientLeft = CAGradientLayer()
            gradientLeft.frame = cell_.rigthView.bounds
            gradientLeft.colors = [ColorsUtility.hexStringToUIColor(hex: themeRigth.grad_start_color!).cgColor,ColorsUtility.hexStringToUIColor(hex: themeRigth.grad_end_color!).cgColor]
            gradientLeft.locations = [0.0, 1.0]
            cell_.rigthView.layer.insertSublayer(gradientLeft, at: 0)
            
            /*
             Set the rigth text
             */
            cell_.labelRigth.text = themeLeft.name
            
            /*
             Event clic for the rigth theme icon
             */
            if(cell_.rigthView.gestureRecognizers?.count == nil){
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(tapGestureRecognizer:)))
                cell_.rigthView?.isUserInteractionEnabled = true
                cell_.rigthView?.tag = row
                cell_.rigthView?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        
        return cell_
    }
    
    
    
    
    /*
     When the user clics on the theme image
     */
    @objc func themeTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        let tappedImage:UIView = tapGestureRecognizer.view as! UIView
        
        /*
            Get the row from the image clicked
         */
        let row:Int = tappedImage.tag
        
        /*
         Get the theme model
         */
        let themeModel:ThemeModel = listThemes.listThemes![row]
        
        /*
            Change the theme app colors
         */
        ThemeSettingsManager.shared.saveTheme(themeModel: themeModel)
        
        /*
            Update the gradient
         */
        uiViewController.updateGradient()
        
        /*
            Change the mini player color
         */
        self.miniPlayer.updateColors()
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
        
        return CGFloat(161)
    }
    
    
    
    
    /*
     Detect when scroll arrives to end
     */
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
