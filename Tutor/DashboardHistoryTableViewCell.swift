//
//  DashboardHistoryTableViewCell.swift
//  
//
//  Created by Matheus Oliveira Rabelo on 7/3/15.
//
//

import UIKit

class DashboardHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var btCall: UIButton!
    
    var user : User?
    
    let radius : (UIView) -> () = { lView in
        lView.layer.masksToBounds = true
        lView.layer.cornerRadius = lView.frame.size.height / 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        radius(self.imgProfile)
        radius(self.btCall)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btCallTouchUpInsideAction(sender: UIButton) {
        
        if let user = self.user{
            NSNotificationCenter.defaultCenter().postNotificationName("callUser", object: user)
        }
    }
}
