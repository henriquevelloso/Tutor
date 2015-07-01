//
//  GlanceController.swift
//  Tutor WatchKit Extension
//
//  Created by Matheus Oliveira Rabelo on 6/30/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {

    @IBOutlet weak var lblLang: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        self.lblLang.setText("?")
        WKInterfaceController.openParentApplication(["get" : "language"], reply: { (result, error) -> Void in
            if let result = result
            {
                if let lang = result["language"] as? String
                {
                    self.lblLang.setText(lang)
                }
            }
        })
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
