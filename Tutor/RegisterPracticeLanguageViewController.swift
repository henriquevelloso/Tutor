//
//  CadastreLearnViewController.swift
//  Tutor
//
//  Created by Natasha Flores on 6/26/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class RegisterPracticeLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewLanguage: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    
    var languageLearnRow:NSInteger = -1
    var languageLearn:PFObject?
    
    var languages : NSArray?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSave.layer.masksToBounds = true
        self.btnSave.layer.cornerRadius = self.btnSave.frame.size.height / 2
        
        Singleton.getLanguages { (langs) -> () in
            self.languages = langs
            self.tableViewLanguage.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let languages = self.languages
        {
            return languages.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageLearn", forIndexPath: indexPath) as! UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if let languages = self.languages{
            let label = cell.viewWithTag(1) as! UILabel
            let langName = languages[indexPath.row]["Name"] as! String
            label.text = langName
            
            let labelAcronym = cell.viewWithTag(3) as! UILabel
            let acronym = languages[indexPath.row]["Acronym"] as! String
            labelAcronym.text = acronym
            
            let bodyView : UIView = cell.viewWithTag(2)!
            
            bodyView.layer.cornerRadius = 4
            bodyView.layer.masksToBounds = true
            
            if(indexPath.row == self.languageLearnRow){
                bodyView.backgroundColor = UIColor(red: 64/255, green: 148/255, blue: 74/255, alpha: 0.5)
            }else{
                bodyView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let languages = self.languages{
            let cell = self.tableViewLanguage.cellForRowAtIndexPath(indexPath)
            
            self.languageLearn = languages[indexPath.row] as? PFObject
            self.languageLearnRow = indexPath.row
            self.tableViewLanguage.reloadData()
        }
        
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
            if let current = self.languageLearn
            {
                User.user.currentLang = current
                user.setObject(current, forKey: "PracticeLanguage")
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
                var alert = UIAlertController(title: "Please", message: "Select a language to learn", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }else{
            undoActivityIndicatorView()
            // If user is not logged in...
            // should never happen :)
        }
        
        
        
    }
    
    
    

}
