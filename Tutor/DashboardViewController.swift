//
//  DashboardViewController.swift
//  
//
//  Created by Matheus Oliveira Rabelo on 6/25/15.
//
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgUserProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    
    @IBOutlet weak var btCall: UIButton!
    @IBOutlet weak var btConfig: UIButton!
    @IBOutlet weak var btLanguage: UIButton!
    
    @IBOutlet weak var tableRecentCalls: UITableView!
    
    var popup : UIViewController?
    
    var recentCalls : NSMutableArray?
    
    let radius : (UIView) -> () = { lView in
        lView.layer.masksToBounds = true
        lView.layer.cornerRadius = lView.frame.size.height / 2
    }
    
    deinit{
        User.user.removeObserver(self, forKeyPath: "currentLang")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        User.user.addObserver(self, forKeyPath: "currentLang", options: NSKeyValueObservingOptions.New, context: nil)
        
        // Load Layout
        radius(self.imgUserProfile)
        radius(self.btLanguage)
        radius(self.btCall)
        
        self.imgUserProfile.layer.borderColor = UIColor.whiteColor().CGColor
        self.imgUserProfile.layer.borderWidth = 3
        
        self.tableRecentCalls.separatorColor = UIColor.clearColor()
        self.tableRecentCalls.backgroundView?.backgroundColor = UIColor.clearColor()
        self.tableRecentCalls.backgroundColor = UIColor.clearColor()
        
        // Load User Data
        if let name = User.user.name{
            self.lblName.text = name
        }
        User.user.getCurrentLanguage { (language) -> () in
            if let currentLang = language
            {
                if let name = currentLang.objectForKey("Name") as? String
                {
                    self.btLanguage.setTitle("Praticando \(name)", forState: UIControlState.Normal)
                }
            }
        }
        
        User.user.getPhoto { (photoData, error) -> () in
            if let photoData = photoData
            {
                self.imgUserProfile.image = UIImage(data: photoData)
            }
        }
        
        
        self.tableRecentCalls.delegate = self
        self.tableRecentCalls.dataSource = self
        
        self.loadHistory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (keyPath == "currentLang")
        {
            User.user.getCurrentLanguage { (language) -> () in
                if let currentLang = language
                {
                    if let name = currentLang.objectForKey("Name") as? String
                    {
                        self.btLanguage.setTitle("Praticando \(name)", forState: UIControlState.Normal)
                    }
                    if let ac = currentLang.objectForKey("Acronym") as? String
                    {
                        NSUserDefaults.standardUserDefaults().setObject(ac, forKey: "currentLanguage")
                    }
                }
                
            }
            
        }
    }
    // Delegates + DataSources
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("recentCall") as! UITableViewCell
        
        if let recents = self.recentCalls
        {
            
            let imgProfile : UIImageView = cell.viewWithTag(1) as! UIImageView
            let lblName : UILabel = cell.viewWithTag(2) as! UILabel
            //let lblLanguage : UILabel = cell.viewWithTag(3) as! UILabel
            let lblDuration : UILabel = cell.viewWithTag(4) as! UILabel
            let btCall : UIButton = cell.viewWithTag(5) as! UIButton
            
            radius(imgProfile)
            radius(btCall)
            
            
            if let history : CallHistory = recents.objectAtIndex(indexPath.row) as? CallHistory
            {
                let madeUser = User()
                if let userMade = history.madeCall
                {
                    madeUser.loadData(userMade)
                }
                
                let receivedUser = User()
                if let userReceived = history.receivedCall
                {
                    receivedUser.loadData(userReceived)
                }
                
                if let duration = history.callDuration
                {
                    lblDuration.text = "Duração da Ligação: \(duration)"
                }
                let fillUserData : (User) -> () = {
                    user in
                    
                    user.getPhoto({ (photoData, error) -> () in
                        if let photoData = photoData
                        {
                            imgProfile.image = UIImage(data: photoData)
                        }
                    })
                    
                    if let userName = user.name
                    {
                        lblName.text = userName
                    }
                }
                
                if let idCurrentUser = User.user.parseUser?.objectId
                {
                    if let idReceived = receivedUser.parseUser?.objectId
                    {
                        if idCurrentUser == idReceived
                        {
                            fillUserData(madeUser)
                        }else{
                            fillUserData(receivedUser)
                        }
                    }
                    if let idMade = madeUser.parseUser?.objectId
                    {
                        if idCurrentUser == idMade
                        {
                            fillUserData(receivedUser)
                        }else{
                            fillUserData(madeUser)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rCalls = self.recentCalls
        {
            return rCalls.count
        }else{
            return 0
        }
    }
    
    
    // Actions
    //@IBAction func btConfigTouchUpInsideAction(sender: AnyObject) {
        //PFUser.logOut()
        //self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UIViewController, animated: true, completion: nil)
    //}
    
    @IBAction func editProfile(sender: UIButton) {
        PFUser.logOut()
        self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UIViewController, animated: true, completion: nil)
        //self.performSegueWithIdentifier("EditProfile", sender: nil)
    }
    
    @IBAction func btChangeLanguageTouchUpInsideAction(sender: UIButton) {
        self.popup = UIStoryboard(name: "Initial", bundle: nil).instantiateViewControllerWithIdentifier("vcPopUpChangeCurrentLanguage") as! UIViewController
        
        if let popup = self.popup as? PopUpChangeCurrentLanguageViewController
        {
            popup.showIn(self)
        }
    }
    
    
    
    // Functions
    func loadHistory(){
        
        User.user.getHistory { (history) -> () in
            self.recentCalls = NSMutableArray()
            for hist in history
            {
                self.recentCalls!.addObject(CallHistory(callHistory: hist as! PFObject))
            }
            self.tableRecentCalls.reloadData()
        }
        
        
    }
    
}
