//
//  EditProfileViewController.swift
//  Tutor
//
//  Created by Natasha Flores on 6/29/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var languages : NSArray?
    
    @IBOutlet weak var tableViewPracticedLanguages: UITableView!
    @IBOutlet weak var imageProfile: UIImageView!
    
    var practiceLangugeSet = Set<PFObject>()
    
    let user = User()
    
    var dataUser = NSMutableArray()
    var dataUserImage = NSMutableArray()
    
    
    var native2: String = ""
    var cont: NSInteger = 0
    
    let radius : (UIView) -> () = { lView in
        lView.layer.masksToBounds = true
        lView.layer.cornerRadius = lView.frame.size.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        self.tableViewPracticedLanguages.tableHeaderView?.frame = CGRectMake(10, 0, self.tableViewPracticedLanguages.frame.size.width, 57)
        
        radius(self.imageProfile)
        
        self.imageProfile.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageProfile.layer.borderWidth = 3
        
        self.dataUser = NSMutableArray()
        self.dataUser = NSMutableArray()
        
        let object = PFUser.currentUser()
        user.loadData(object!)
        
        user.getNativeLanguage{(native) -> () in
            let name = native?.objectForKey("Name") as? String
            
            self.native2 = "Native in " + name!
            self.tableViewPracticedLanguages.reloadData()
        }
        
        self.dataUserImage = ["icon-profile", "icon-gender", "icon-mail", "icon-talk"]
        
        user.getPhoto({ (photoData, error) -> () in
            if error == nil
            {
                self.imageProfile.image = UIImage(data: photoData!)
            }
        })
        
        var query = PFQuery(className: "CallHistory")
        query.includeKey("PracticeLanguage")
        query.whereKey("MadeCall", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock{
            (objects, error) -> Void in
            if error == nil{
                if let objects = objects as? [PFObject]{
                    for object in objects {
                        let practice = object["PracticeLanguage"] as! PFObject
                        //let s = practice.objectForKey("Name") as! String
                        self.practiceLangugeSet.insert(practice)
                    }
                }
                //print(self.practiceLangugeSet.description)
                self.tableViewPracticedLanguages.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height : CGFloat = 20
        
        switch(section)
        {
        case 1:
            height = 54
        default:
            height = 0
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section)
        {
        case 0:
            return 4
        case 1:
            return self.practiceLangugeSet.count
        case 2:
            return 1
        default:
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        self.dataUser = [self.user.name!, self.user.gender!, self.user.email!, self.native2]
        
        var cell : UITableViewCell!
        var imageName : UIImageView!
        var labelAcronym : UILabel!
        var labelName : UILabel!
        
        if (indexPath.section == 0 || indexPath.section == 1){
            
            cell = tableView.dequeueReusableCellWithIdentifier("simpleDetail", forIndexPath: indexPath) as! UITableViewCell
            
            imageName = cell.viewWithTag(3) as! UIImageView
            labelName = cell.viewWithTag(2) as! UILabel
            labelAcronym = cell.viewWithTag(1) as! UILabel
        }
        switch(indexPath.section)
        {
        case 0:
            labelAcronym.hidden = true
            
            imageName.hidden = false
            labelName.text = self.dataUser[indexPath.row] as? String
            var i = self.dataUserImage[indexPath.row] as? String
            imageName.image = UIImage(named: i!)
        case 1:
            labelAcronym.hidden = false
            
            imageName.image = UIImage(named: "back-short-language")
            
            let pf = self.practiceLangugeSet[advance(self.practiceLangugeSet.startIndex, indexPath.row)]
            
            labelName.text = pf["Name"] as? String
            labelAcronym.text = pf["Acronym"] as? String
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("cellLogout", forIndexPath: indexPath) as! UITableViewCell
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view:UIView = UIView()
        
        if(section == 1){
            view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 57))
            
            let lblTitle = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
            
            lblTitle.text = "Linguagens Praticadas"
            
            lblTitle.textColor = UIColor.whiteColor()
            lblTitle.textAlignment = .Center
            lblTitle.center = view.center
            
            view.addSubview(lblTitle)
            
            view.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            
        }else if (section == 0){
            tableView.tableHeaderView?.frame = CGRectMake(0, 0, tableView.frame.size.width, 0)
        }
        
        return view
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0 || indexPath.section == 2)
        {
            return 42
        }else{
            return 62
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableViewPracticedLanguages.deselectRowAtIndexPath(indexPath, animated: true)
        if(indexPath.section == 2)
        {
            PFUser.logOut()
            self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UIViewController, animated: true, completion: nil)
        }
    }

    
}
