//
//  CadastreViewController.swift
//  Tutor
//
//  Created by Natasha Flores on 6/25/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class CadastreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var language = NSMutableArray()
    @IBOutlet weak var tableViewLanguage: UITableView!
    var languageNative:PFObject?
    var languageNativeRow:NSInteger = -1
    

    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.language = NSMutableArray()
        
        self.btnNext.layer.masksToBounds = true
        self.btnNext.layer.cornerRadius = self.btnNext.frame.size.height / 2
        
        // Get languages of Parse
        var query = PFQuery(className:"Language")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.language.addObject(object)
                    }
                }
                self.tableViewLanguage.reloadData()
            }
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.language.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        
//        if (indexPath.row % 2 == 0) {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("Language", forIndexPath: indexPath) as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let label = cell.viewWithTag(1) as! UILabel
            let languages = self.language[indexPath.row]["Name"] as! String // [indexPath.row/2]
            label.text = languages
            
            if(indexPath.row == self.languageNativeRow){
                cell.backgroundColor = UIColor(red: 64/255, green: 148/255, blue: 74/255, alpha: 0.10)
            }else{
                cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.10)
            }
            
            return cell
//        }
//        else {
//            let cell2 = tableView.dequeueReusableCellWithIdentifier("Separate", forIndexPath: indexPath) as! UITableViewCell
//            cell2.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
//            return cell2
//        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableViewLanguage.cellForRowAtIndexPath(indexPath)
        //let image = cell?.viewWithTag(2) as! UIImageView
        
        //image.image = UIImage(named: "check")
        cell?.backgroundColor = UIColor(red: 64/255, green: 148/255, blue: 74/255, alpha: 0.10)
        
        self.languageNative = self.language[indexPath.row] as? PFObject
        self.languageNativeRow = indexPath.row
        self.tableViewLanguage.reloadData()
        
        //            image.image = UIImage(named: "uncheck")
        
    }
    @IBAction func saveParseLanguageNative(sender: UIButton) {
        var userLanguageNative = PFUser.currentUser()
        var lan:String = self.languageNative!.objectId!
        userLanguageNative?.setObject(PFObject(withoutDataWithClassName: "Language", objectId: lan), forKey: "NativeLanguage")
        userLanguageNative?.saveInBackground()
    }
}
