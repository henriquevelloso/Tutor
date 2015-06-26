//
//  CadastreLearnViewController.swift
//  Tutor
//
//  Created by Natasha Flores on 6/26/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class CadastreLearnViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewLanguage: UITableView!
    var languageNative:PFObject?
    var languageLearnRow:NSInteger = -1
    var languageLearn:PFObject?
    var s: Singleton = Singleton.sharedInstance
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSave.layer.masksToBounds = true
        self.btnSave.layer.cornerRadius = self.btnSave.frame.size.height / 2
        self.tableViewLanguage.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.s.language.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageLearn", forIndexPath: indexPath) as! UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let label = cell.viewWithTag(1) as! UILabel
        let languages = self.s.language[indexPath.row]["Name"] as! String
        label.text = languages
        
        let labelAcronym = cell.viewWithTag(3) as! UILabel
        let acronym = self.s.language[indexPath.row]["Acronym"] as! String
        labelAcronym.text = acronym
        
        let bodyView : UIView = cell.viewWithTag(2)!
        
        bodyView.layer.cornerRadius = 4
        bodyView.layer.masksToBounds = true
        
        if(indexPath.row == self.languageLearnRow){
            bodyView.backgroundColor = UIColor(red: 64/255, green: 148/255, blue: 74/255, alpha: 0.5)
        }else{
            bodyView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableViewLanguage.cellForRowAtIndexPath(indexPath)
        
        self.languageLearn = self.s.language[indexPath.row] as? PFObject
        self.languageLearnRow = indexPath.row
        self.tableViewLanguage.reloadData()
        
    }
    
    @IBAction func saveParseLanguageLearn(sender: UIButton) {
        self.btnSave.setTitle("", forState: UIControlState.Disabled)
        self.btnSave.enabled = false
        
        let aView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        aView.hidesWhenStopped = true
        aView.center = self.btnSave.center
        self.view.addSubview(aView)
        aView.startAnimating()
        
        let undoActivityIndicatorView : (() -> ()) = {
            aView.stopAnimating()
            aView.removeFromSuperview()
            self.btnSave.enabled = true
        }
        
        if let user = User.user.parseUser
        {
            
            var lan:String = self.languageLearn!.objectId!
            user.setObject(PFObject(withoutDataWithClassName: "Language", objectId: lan), forKey: "PracticeLanguage")
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
