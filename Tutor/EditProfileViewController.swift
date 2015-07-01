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
    
    @IBOutlet weak var logOut: UIButton!
    
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
        
        self.logOut.layer.masksToBounds = true
        self.logOut.layer.cornerRadius = self.logOut.frame.size.height / 2
        self.logOut.backgroundColor = UIColor(red: 193/255, green: 114/255, blue: 114/255, alpha: 1)
        
        self.dataUser = NSMutableArray()
        self.dataUser = NSMutableArray()
        
        let object = PFUser.currentUser()
        user.loadData(object!)
        
        user.getNativeLanguage{(native) -> () in
            let name = native?.objectForKey("Name") as? String
            
            self.native2 = "Native in " + name!
            self.tableViewPracticedLanguages.reloadData()
        }
        
        self.dataUserImage = ["NameFilled-100", "GenderFilled-100", "MessageFilled-100", "TalkFilled-100"]
        
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
    
    @IBAction func BackDashBoard(sender: UIButton) {
        self.performSegueWithIdentifier("BackDashBoard", sender: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            
            return 4
            
        }
            
        else{
            
            return self.practiceLangugeSet.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        self.dataUser = [self.user.name!, self.user.gender!, self.user.email!, self.native2]
        
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("simpleDetail", forIndexPath: indexPath) as! UITableViewCell
        
        
        
        let imageName = cell.viewWithTag(3) as! UIImageView
        
        let labelName = cell.viewWithTag(2) as! UILabel
        
        let labelAcronym = cell.viewWithTag(1) as! UILabel
        
        
        
        if(indexPath.section == 0)
            
        {
            
            labelAcronym.hidden = true
            
            imageName.hidden = false
            
            labelName.text = self.dataUser[indexPath.row] as? String
            
            var i = self.dataUserImage[indexPath.row] as? String
            
            imageName.image = UIImage(named: i!)
            
            
            
        }
            
        else
            
        {
            
            labelAcronym.hidden = false
            
            imageName.image = UIImage(named: "back-short-language")
            
            let pf = self.practiceLangugeSet[advance(self.practiceLangugeSet.startIndex, indexPath.row)]
            
            labelName.text = pf["Name"] as? String
            
            labelAcronym.text = pf["Acronym"] as? String
            
        }
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view:UIView = UIView()
        
        if(section == 1){
            
            var string = "Practiced Languages"
            
            view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 57))
            
            let labelName = UILabel(frame: CGRectMake(0, 0, tableView.frame.size.width, 30))
            
            labelName.text = string
            
            labelName.textColor = UIColor.whiteColor()
            labelName.textAlignment = .Center
            
            view.addSubview(labelName)
            
            view.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
  
        }else{
            tableView.tableHeaderView?.frame = CGRectMake(0, 0, tableView.frame.size.width, 0)
        }
        
        
        
        return view
        
    }
    
    @IBAction func logOut(sender: UIButton) {
        PFUser.logOut()
        self.presentViewController(UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UIViewController, animated: true, completion: nil)
    }
    
}
