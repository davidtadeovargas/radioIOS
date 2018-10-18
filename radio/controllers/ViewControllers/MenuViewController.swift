//
//  MenuViewController.swift
//  radio
//
//  Created by MacBook 13 on 7/4/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    /*
        Constants
     */
    
    let rows = 10

    /*
     End of Constants
     */
    
    
    
    /*
     Override methods
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        tableView.layoutIfNeeded()
        preferredContentSize = CGSize(width: 200, height: 400)
        tableView.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(rows)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if(indexPath.row==0){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_0
        }
        else if(indexPath.row==1){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_1
        }
        else if(indexPath.row==2){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_2
        }
        else if(indexPath.row==3){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_3
        }
        else if(indexPath.row==4){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_4
        }
        else if(indexPath.row==5){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_5
        }
        else if(indexPath.row==6){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_6
        }
        else if(indexPath.row==7){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_7
        }
        else if(indexPath.row==8){
            cell.textLabel?.text = Constants.MAIN_MENU_INDEX_8
        }
        cell.textLabel?.font = .boldSystemFont(ofSize: 12)
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .clear
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*
            Depends wich menu was selected
         */
        switch(indexPath.row){
            
            //Rate me now
            case 0:
                self.openRateMeNow()
                break;
            
            //Visit Our Facebook
            case 1:
                self.openVisitFacebook()
                break;
            
            //Visit our twitter
            case 2:
                self.openVisitTwitter()
                break;
            
            //Visit our instagram
            case 3:
                self.openVisitInstagram()
                break;
            
            //Visit our website
            case 4:
                self.openVisitWebSite()
                break;
            
            //Tell a friend
            case 5:
                tellAFriend()
                break;
            
            //Contat us
            case 6:
                break;
            
            //Privacy policy
            case 7:
                self.openPrivacyPolicy()
                break;
            
            //Terms of use
            case 8:
                self.openTermsOfUse()
                break;
            
        default:
            break
        }
    }
    /*
     End of Override methods
     */
    
    /*
        Private methods
     */
    private func openRateMeNow(){
        UIApplication.shared.openURL(NSURL(string: Constants.RATE_ME_NOW_URL)! as URL)
    }
    private func openVisitFacebook(){
        self.openURL(url: Constants.FACEBOOK_URL, text:Constants.FACEBOOK_TEXT)
    }
    private func openVisitTwitter(){
        self.openURL(url: Constants.TWITTER_URL, text:Constants.TWITTER_TEXT)
    }
    private func openVisitInstagram(){
        self.openURL(url: Constants.INSTAGRAM_URL, text:Constants.INSTAGRAM_TEXT)
    }
    private func openVisitWebSite(){
        self.openURL(url: Constants.WEBSITE_URL, text:Constants.WEBSITE_TEXT)
    }
    private func openPrivacyPolicy(){
        self.openURL(url: URLS.PRIVACY_POLICY, text: Constants.PROVACY_POLICY_TEXT)
    }
    private func openTermsOfUse(){
        self.openURL(url: URLS.TERM_OF_USE, text: Constants.TERMS_USE_TEXT)
    }
    private func tellAFriend(){
        let textToShare = "Let start with Radio now!"
        if let myWebsite = NSURL(string: Constants.PLAYSTORE_URL) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    private func openURL(url:String,text:String){
        
        /*
            Prepare parameters to pass
         */
        Parameters.sharedInstance.url = url
        Parameters.sharedInstance.text = text
        
        /*
         Remove the current window
         */
        self.dismiss(animated: true, completion: nil)
        
        /*
         Open the facebook URL
         */
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        Parameters.sharedInstance.UIViewController?.present(newViewController, animated: true, completion: nil)
    }
    /*
        End of private methods
     */
}
