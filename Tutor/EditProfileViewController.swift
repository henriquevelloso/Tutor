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
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var genderProfile: UILabel!
    @IBOutlet weak var emailProfile: UILabel!
    @IBOutlet weak var nativeLanguageProfie: UILabel!
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    var practiceLangugeSet = Set<String>()
    
    let radius : (UIView) -> () = { lView in
        lView.layer.masksToBounds = true
        lView.layer.cornerRadius = lView.frame.size.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        radius(self.imageProfile)
        
        self.imageProfile.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageProfile.layer.borderWidth = 3
        
        let user = User()
        let object = PFUser.currentUser()
        user.loadData(object!)
        
        self.nameProfile.text = user.name
        self.genderProfile.text = user.gender
        self.emailProfile.text = user.email
        
        user.getNativeLanguage{(native) -> () in
            let name = native?.objectForKey("Name") as? String
            
            self.nativeLanguageProfie.text = "Native in " + name!
        }
        
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
                        let s = practice.objectForKey("Name") as! String
                        self.practiceLangugeSet.insert(s)
                    }
                }
                print(self.practiceLangugeSet.description)
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
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.practiceLangugeSet.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleDetail", forIndexPath: indexPath) as! UITableViewCell
        
        let labelName = cell.viewWithTag(2) as! UILabel
        let labelAcronym = cell.viewWithTag(1) as! UILabel
        
        let pf = self.practiceLangugeSet[advance(self.practiceLangugeSet.startIndex, indexPath.row)]

        labelName.text = pf
        
        return cell
    }
}
