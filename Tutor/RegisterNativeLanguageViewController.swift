//
//  CadastreViewController.swift
//  Tutor
//
//  Created by Natasha Flores on 6/25/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit

class RegisterNativeLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewLanguage: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    
    var languageNative:PFObject?
    var languageNativeRow:NSInteger = -1
    
    var languages : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Singleton.getLanguages { (langs) -> () in
            self.languages = langs
            self.tableViewLanguage.reloadData()
        }
        
        self.btnNext.layer.masksToBounds = true
        self.btnNext.layer.cornerRadius = self.btnNext.frame.size.height / 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Language", forIndexPath: indexPath) as! UITableViewCell
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
            
            if(indexPath.row == self.languageNativeRow){
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
            
            self.languageNative = languages[indexPath.row] as? PFObject
            self.languageNativeRow = indexPath.row
            self.tableViewLanguage.reloadData()
            
        }
    }
    
    @IBAction func saveParseLanguageNative(sender: UIButton) {
        self.btnNext.setTitle("", forState: UIControlState.Disabled)
        self.btnNext.enabled = false
        
        let aView : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        aView.hidesWhenStopped = true
        aView.center = self.btnNext.center
        self.view.addSubview(aView)
        aView.startAnimating()
        
        let undoActivityIndicatorView : (() -> ()) = {
            aView.stopAnimating()
            aView.removeFromSuperview()
            self.btnNext.enabled = true
        }
        
        if let user = User.user.parseUser
        {
            if let native = self.languageNative{
                
                User.user.nativeLang = native
                
                user.setObject(native, forKey: "NativeLanguage")
                user.saveInBackgroundWithBlock({ (successed, error) -> Void in
                    undoActivityIndicatorView()
                    if let error = error{
                        //
                    }else{
                        self.performSegueWithIdentifier("segueToPracticeLanguage", sender: nil)
                    }
                })
                
            }else{
                
                undoActivityIndicatorView()
                var alert = UIAlertController(title: "Por Favor", message: "Selecione seu idioma nativo", preferredStyle: UIAlertControllerStyle.Alert)
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
