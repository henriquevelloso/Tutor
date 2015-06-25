//
//  ViewController.swift
//  Tutor
//
//  Created by Henrique Velloso on 6/23/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit
 

class ViewController: UIViewController {
    @IBOutlet weak var constraintIconPos: NSLayoutConstraint!
    @IBOutlet weak var constraintTitlePos: NSLayoutConstraint!
    @IBOutlet weak var constraintSubtitlePos: NSLayoutConstraint!
    @IBOutlet weak var constraintLoginButton: NSLayoutConstraint!
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btLogin: UIButton!
    
    
    var initIconPosConst : CGFloat!
    var initTitlePosConst : CGFloat!
    var initSubtitlePosConst : CGFloat!
    var initButtonPosConst : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initIconPosConst = self.constraintIconPos.constant
        self.initTitlePosConst = self.constraintTitlePos.constant
        self.initSubtitlePosConst = self.constraintSubtitlePos.constant
        self.initButtonPosConst = self.constraintLoginButton.constant
        
        self.constraintIconPos.constant = -self.view.frame.size.height
        self.constraintTitlePos.constant = -self.view.frame.size.height
        self.constraintSubtitlePos.constant = -self.view.frame.size.height
        self.constraintLoginButton.constant = -self.view.frame.size.height
        
        self.btLogin.layer.masksToBounds = true
        self.btLogin.layer.cornerRadius = 3
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate Icon Image
        self.constraintIconPos.constant = self.initIconPosConst + 8
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.imgIcon.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.constraintIconPos.constant = self.initIconPosConst
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.imgIcon.layoutIfNeeded()
                    }, completion: nil)
        })
        
        
        // Animate Title Label
        self.constraintTitlePos.constant = self.initTitlePosConst + 8
        UIView.animateWithDuration(0.6, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.lblTitle.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.constraintTitlePos.constant = self.initTitlePosConst
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.lblTitle.layoutIfNeeded()
                    }, completion: nil)
        })
        
        // Animate Subtitle Label
        self.constraintSubtitlePos.constant = self.initSubtitlePosConst + 8
        UIView.animateWithDuration(0.6, delay: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.lblSubtitle.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.constraintSubtitlePos.constant = self.initSubtitlePosConst
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.lblSubtitle.layoutIfNeeded()
                    }, completion: nil)
        })
        
        // Animate Button
        self.constraintLoginButton.constant = self.initButtonPosConst + 8
        UIView.animateWithDuration(0.6, delay: 0.6, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.btLogin.layoutIfNeeded()
            }, completion: { (completed) -> Void in
                self.constraintLoginButton.constant = self.initButtonPosConst
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.btLogin.layoutIfNeeded()
                    }, completion: nil)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btLoginTouchUpInsideAction(sender: UIButton) {
        /*PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "user_friends", "email"]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    
                    var request : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                    request.startWithCompletionHandler({ (connection, result, error) -> Void in
                        if let fb = result as? NSDictionary{
                            
                            // Facebook
                            var fbid : String = fb.objectForKey("id") as! String
                            var email : String = fb.objectForKey("email") as! String
                            var name : String = fb.objectForKey("name") as! String
                            var gender : String = fb.objectForKey("gender") as! String
                            // locale = "pt_BR"
                            
                            var imgProfileLink : String = "https://graph.facebook.com/\(fbid)/picture?type=large&return_ssl_resources=1"
                            let imgProfileURL = NSURL(string: imgProfileLink)
                            let imgProfileData = NSData(contentsOfURL: imgProfileURL!)
                            
                            
                            
                            // Parse
                            user.email = email
                            user.setObject(fbid, forKey: "facebookId")
                            user.setObject(name, forKey: "name")
                            user.setObject(gender, forKey: "gender")
                            
                            if let imgProfileData = imgProfileData
                            {
                                var file : PFFile = PFFile(name: "default", data: imgProfileData)
                                user.setObject(file, forKey: "image")
                            }
                            user.saveInBackgroundWithBlock({ (successed, error) -> Void in
                                self.performSegueWithIdentifier("segueLoginToWelcome", sender: nil)
                            })
                        }
                    })
                    
                    
                } else {
                    
                    println("User logged in through Facebook!")
                    self.performSegueWithIdentifier("segueLoginToWelcome", sender: nil)
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }*/
    }
    
    
    
    
}

