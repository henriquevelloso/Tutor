//
//  TTWelcomeViewController.swift
//  
//
//  Created by Matheus Oliveira Rabelo on 6/24/15.
//
//

import UIKit

class TTWelcomeViewController: UIViewController {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var btNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imgUserProfile.layer.masksToBounds = true
        self.imgUserProfile.layer.cornerRadius = self.imgUserProfile.frame.size.width / 2
        self.imgUserProfile.layer.borderColor = UIColor.whiteColor().CGColor
        self.imgUserProfile.layer.borderWidth = 3
        
        self.btNext.layer.masksToBounds = true
        self.btNext.layer.cornerRadius = self.btNext.frame.size.height / 2
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        User.user.getPhoto { (imgData, error) -> () in
            if let imgData = imgData{
                self.imgUserProfile.image = UIImage(data: imgData)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btNextTouchUpInsideAction(sender: AnyObject) {
        PFUser.logOut()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
