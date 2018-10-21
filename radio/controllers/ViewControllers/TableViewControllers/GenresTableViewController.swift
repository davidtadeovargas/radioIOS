//
//  GenresTableViewController.swift
//  radio
//
//  Created by MacBook 13 on 8/6/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit

class GenresTableViewController: UITableViewController,GenresResponseProtocol,NetError {
    
    var listGenres:[GenreModel]! //Contains the genres list
    var responseTableConnection:ResponseTableConnection! //Deliver results to controller
    
    //Contains the total of the rows
    var rowsCount:Int = 0
    
    private var rowSelection:RowSelection! = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.separatorStyle = .none //Remove line separatos
        
        //self.tableView.register(GenresViewCell.self, forCellReuseIdentifier: "GenresViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        /*
         Remove the extra initial top padding of the table
         */
        //self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        updateWithServer()
    }

    func setRowSelection(rowSelection:RowSelection){
        self.rowSelection = rowSelection
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
        if(self.listGenres != nil){
            return self.listGenres.count / 2
        }
        else{
            return 0
        }
    }
    
    
    
    
    /*
     Update the table with the server by filters
     */
    func updateWithServer(){
        
        do {
            
            /*
             Consume the webservice
             */
            let genresListNetController:GenresListNetController = GenresListNetController()
            genresListNetController.onResponseProtocol = self
            genresListNetController.onError = self //Error handler for connection
            try genresListNetController.task()
            
        } catch {
            
            /*
             Print error to console
             */
            print(error)
        }
    }
    
    
    
    /*
     Error handling for protocol connections
     */
    func onError(error: AnyObject) {
        
        /*
         Just deliver the response, we dont have to control this phase
         */
        self.responseTableConnection.onError(error: error)
    }
    
    /*
     Implementation response genres protocol
     */
    func result(data: [GenreModel]) {
        
        self.rowsCount = data.count //Set the total of rows of the table
        self.listGenres = data as [GenreModel] //Set the array of results
        
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
        let cell_:GenresViewCell = self.tableView.dequeueReusableCell(withIdentifier: "GenresViewCell", for:indexPath) as! GenresViewCell
        
        /*
         Set the local row
         */
        var row:Int = indexPath.row
        
        row = row + row
        
        /*
         Get the left genre model
         */
        let genreLeft:GenreModel = listGenres![row]
        
        /*
         Set the label left text
         */
        cell_.labelLeft.text = genreLeft.name
        
        /*
            Set the left image
         */
        let imageUrlString = URLS.GENRES_HOST + genreLeft.img!
        let imageUrl:URL = URL(string: imageUrlString)!
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                
                let image:UIImage = UIImage(data: imageData as Data)!
                cell_.leftImage.image = image
            }
        }
    
        /*
         Event clic for the rigth theme icon
         */
        if(cell_.leftImage.gestureRecognizers?.count == nil){
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(tapGestureRecognizer:)))
            cell_.leftImage?.isUserInteractionEnabled = true
            cell_.leftImage?.tag = row
            cell_.leftImage?.addGestureRecognizer(tapGestureRecognizer)
        }
        
        row = row + 1 //Add one to go for the rigth value
        
        /*
         If should paint the rigth image icon
         */
        if(row < rowsCount){
            
            /*
             Get the rogth genre model
             */
            let genreRigth:GenreModel = listGenres![row]
            
            /*
             Set the label rogth text
             */
            cell_.labelRigth.text = genreRigth.name
            
            
            /*
             Set the rigth image
             */
            let imageUrlString = URLS.GENRES_HOST + genreRigth.img!
            let imageUrl:URL = URL(string: imageUrlString)!
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async {
                    
                    let image:UIImage = UIImage(data: imageData as Data)!
                    cell_.rigthImage.image = image
                }
            }
            
            /*
             Event clic for the rigth theme icon
             */
            if(cell_.rigthImage.gestureRecognizers?.count == nil){
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(themeTapped(tapGestureRecognizer:)))
                cell_.rigthImage?.isUserInteractionEnabled = true
                cell_.rigthImage?.tag = row
                cell_.rigthImage?.addGestureRecognizer(tapGestureRecognizer)
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
         Get the genre model
         */
        let genre:GenreModel = listGenres![row]
        
        if(self.rowSelection != nil){
           self.rowSelection.onRowSelection(genre: genre)
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
        
        return CGFloat(168)
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
