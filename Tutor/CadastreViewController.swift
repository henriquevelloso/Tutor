//
//  CadastreViewController.swift
//  Tutor
//
//  Created by Natasha Flores on 6/25/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class CadastreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewLanguage: UITableView!
    @IBOutlet weak var btNext: UIButton!
    
    
    var language = NSMutableArray()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Language", forIndexPath: indexPath) as! UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let label = cell.viewWithTag(1) as! UILabel
        let languages = self.language[indexPath.row]["Name"] as! String // [indexPath.row/2]
        label.text = languages
        
        let bodyView : UIView = cell.viewWithTag(2)!
        
        bodyView.layer.cornerRadius = 4
        bodyView.layer.masksToBounds = true
        
        
        if(indexPath.row == self.languageNativeRow){
            bodyView.backgroundColor = UIColor(red: 64/255, green: 148/255, blue: 74/255, alpha: 0.5)
        }else{
            bodyView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableViewLanguage.cellForRowAtIndexPath(indexPath)
        
        self.languageNative = self.language[indexPath.row] as? PFObject
        self.languageNativeRow = indexPath.row
        self.tableViewLanguage.reloadData()
        
    }
    @IBAction func saveParseLanguageNative(sender: UIButton) {
        self.btNext.setTitle("", forState: UIControlState.Disabled)
        self.btNext.enabled = false
        
        let aView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        aView.hidesWhenStopped = true
        aView.center = self.btNext.center
        self.view.addSubview(aView)
        aView.startAnimating()
        
        let undoActivityIndicatorView : (() -> ()) = {
            aView.stopAnimating()
            aView.removeFromSuperview()
            self.btNext.enabled = true
        }
        
        if let user = User.user.parseUser
        {
            
            var lan:String = self.languageNative!.objectId!
            user.setObject(PFObject(withoutDataWithClassName: "Language", objectId: lan), forKey: "NativeLanguage")
            user.saveInBackgroundWithBlock({ (successed, error) -> Void in
                undoActivityIndicatorView()
                if let error = error{
                    //
                }else{
                    self.presentViewController(UIStoryboard(name: "Initial", bundle: nil).instantiateInitialViewController() as! UIViewController, animated: true, completion: nil)
                }
            })
        }else{
            undoActivityIndicatorView()
            // If user is not logged in...
            // should never happen :)
        }
        
        
        
    }
}
