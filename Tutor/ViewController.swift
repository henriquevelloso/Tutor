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

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    var initIconPosConst : CGFloat!
    var initTitlePosConst : CGFloat!
    var initSubtitlePosConst : CGFloat!
    var btnLogin : FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.initIconPosConst = self.constraintIconPos.constant
        self.initTitlePosConst = self.constraintTitlePos.constant
        self.initSubtitlePosConst = self.constraintSubtitlePos.constant
        
        self.constraintIconPos.constant = -self.view.frame.size.height
        self.constraintTitlePos.constant = -self.view.frame.size.height
        self.constraintSubtitlePos.constant = -self.view.frame.size.height
        
        var loginPoint : CGPoint = self.view.center
        loginPoint.y = self.view.frame.size.height + 100
        
        self.btnLogin = FBSDKLoginButton()
        self.btnLogin.center = loginPoint
        self.view.addSubview(self.btnLogin)
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
        var buttonPoint : CGPoint = self.view.center
        buttonPoint.y = buttonPoint.y + 150
        
        UIView.animateWithDuration(0.6, delay: 0.6, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            var loginPoint : CGPoint = buttonPoint
            loginPoint.y = loginPoint.y - 8
            
            self.btnLogin.center = loginPoint
            
            }, completion: { (completed) -> Void in
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.btnLogin.center = buttonPoint
                    }, completion: nil)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    

}

