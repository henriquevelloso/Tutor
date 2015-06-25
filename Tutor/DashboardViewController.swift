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
    
    let radius : (UIView) -> () = { lView in
        lView.layer.masksToBounds = true
        lView.layer.cornerRadius = lView.frame.size.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        User.user.getPhoto { (photoData, error) -> () in
            if let photoData = photoData
            {
                self.imgUserProfile.image = UIImage(data: photoData)
            }
        }
        
        self.tableRecentCalls.delegate = self
        self.tableRecentCalls.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Delegates + DataSources
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("recentCall") as! UITableViewCell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
}
