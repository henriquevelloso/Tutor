//
//  CallHistoryInterfaceController.swift
//  
//
//  Created by Matheus Oliveira Rabelo on 7/1/15.
//
//

import WatchKit
import Foundation

class CallHistoryInterfaceController: WKInterfaceController {

    @IBOutlet weak var tableHistory: WKInterfaceTable!
    var history : NSArray?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        WKInterfaceController.openParentApplication(["get": "history"], reply: { (result, error) -> Void in
            
            println(result)
            if let result = result
            {
                if let historyData = result["history"] as? NSArray
                {
                    self.history = historyData
                    self.reloadTable()
                }
            }
        })
    }
    
    func reloadTable(){
        if let history = self.history
        {
            self.tableHistory.setNumberOfRows(history.count, withRowType: "cellHistory")
            for i in 0..<history.count {
                let row: CallHistoryContentCell = self.tableHistory.rowControllerAtIndex(i) as! CallHistoryContentCell
                
                let rowData = history.objectAtIndex(i) as! NSArray
                
                if rowData.count == 3{
                    let mins = rowData.objectAtIndex(0) as! String
                    let name = rowData.objectAtIndex(1) as! String
                    let imgData = rowData.objectAtIndex(2) as! NSData
                    
                    row.lblName.setText(name)
                    row.lblMin.setText(mins)
                    row.imgUser.setBackgroundImage(UIImage(data: imgData))
                }
            }
        }else{
            //self.tableHistory.setNumberOfRows(1, withRowType: "cellNoRow")
            
        }
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
