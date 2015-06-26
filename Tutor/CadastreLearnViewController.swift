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
    var language1 = NSMutableArray()
    var languageNative:PFObject?
    var s: Singleton = Singleton.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0//self.language.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageLearn", forIndexPath: indexPath) as! UITableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    

}
