//
//  ViewController.swift
//  Tutor
//
//  Created by Henrique Velloso on 6/23/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit
 

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        var loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
//        
//        
//        FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//        loginButton.center = self.view.center;
//        [self.view addSubview:loginButton];
//        
//        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}

