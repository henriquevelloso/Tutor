//
//  CallHistory.swift
//  
//
//  Created by Matheus Oliveira Rabelo on 6/26/15.
//
//

import UIKit

class CallHistory: NSObject {
    
    var parseCallHistory : PFObject?
    
    init(callHistory : PFObject){
        self.parseCallHistory = callHistory
    }
    
    var madeCall : PFUser? {
        return parseCallHistory!.objectForKey("MadeCall") as? PFUser
    }
    
    var receivedCall : PFUser? {
        return parseCallHistory!.objectForKey("ReceivedCall") as? PFUser
    }
    
    var callLanguage : PFObject? {
        return parseCallHistory!.objectForKey("PracticedLang") as? PFObject
    }
    
    
    var madeCallPoints : Int? {
        return parseCallHistory!.objectForKey("MadeCallPoints") as? Int
    }
    var receivedCallPoints : Int? {
        return parseCallHistory!.objectForKey("ReceivedCallPoints") as? Int
    }
    
    var callDuration : Float? {
        return parseCallHistory!.objectForKey("CallDuration") as? Float
    }
}
