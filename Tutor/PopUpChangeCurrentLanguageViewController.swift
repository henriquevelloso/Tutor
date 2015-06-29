//
//  PopUpChangeCurrentLanguageViewController.swift
//  
//
//  Created by Matheus Oliveira Rabelo on 6/29/15.
//
//

import UIKit

class PopUpChangeCurrentLanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btCancel: UIButton!
    
    @IBOutlet weak var tableViewLanguages: UITableView!
    
    var selectedLanguage : PFObject?
    var selectedLanguageRow : Int = -1;
    
    var languages : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 6
        
        self.btCancel.layer.masksToBounds = true
        self.btCancel.layer.cornerRadius = 6
        
        self.tableViewLanguages.delegate = self
        self.tableViewLanguages.dataSource = self
        
        Singleton.getLanguages { (langs) -> () in
            self.languages = langs
            self.tableViewLanguages.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Action
    @IBAction func btCloseTouchUpInsideAction(sender: UIButton) {
        self.close()
    }

    
    // Functions
    func showIn(viewController : UIViewController)
    {
        self.view.frame = viewController.view.frame
        self.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8)
        self.view.alpha = 0
        
        viewController.view.addSubview(self.view)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.view.alpha = 1
            self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            
        }) { (successed) -> Void in
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
            }) { (successed) -> Void in
                    
            }
        }
    }
    func close()
    {
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1)
        }) { (successed) -> Void in
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                
                self.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                self.view.alpha = 0
                
                }) { (successed) -> Void in
                    self.view.removeFromSuperview()
            }
        }
    }
    
    // DataSource + Delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = self.tableViewLanguages.dequeueReusableCellWithIdentifier("cellLanguage") as! UITableViewCell
        
        if let languages = self.languages{
            let label = cell.viewWithTag(1) as! UILabel
            label.text = languages[indexPath.row]["Name"] as? String
            
            let labelAcronym = cell.viewWithTag(3) as! UILabel
            labelAcronym.text = languages[indexPath.row]["Acronym"] as? String
            
            let bodyView : UIView = cell.viewWithTag(2)!
            
            bodyView.layer.cornerRadius = 4
            bodyView.layer.masksToBounds = true
            
            if(indexPath.row == self.selectedLanguage){
                bodyView.backgroundColor = UIColor(red: 64/255, green: 148/255, blue: 74/255, alpha: 0.5)
            }else{
                bodyView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let languages = self.languages
        {
            return languages.count
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if let languages = self.languages
        {
            let cell = self.tableViewLanguages.cellForRowAtIndexPath(indexPath)
            
            self.selectedLanguage = languages[indexPath.row] as? PFObject
            self.selectedLanguageRow = indexPath.row
            self.tableViewLanguages.reloadData()
        }
    }

}
