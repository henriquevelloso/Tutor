//
//  Singleton.swift
//  Tutor
//
//  Created by Natasha Flores on 6/26/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import Foundation

class Singleton {
    
    class var sharedInstance: Singleton {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Singleton? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Singleton()
        }
        return Static.instance!
    }
}