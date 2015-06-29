//
//  Singleton.swift
//  Tutor
//
//  Created by Natasha Flores on 6/26/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import Foundation

class Singleton {
    static var languages : NSArray?
    
    class func getLanguages(response : (NSArray?) -> ()){
        if let langs = Singleton.languages
        {
            response(langs)
        }else{
            // Get languages from Parse
            var query = PFQuery(className:"Language")
            
            query.findObjectsInBackgroundWithBlock {
                (objects, error) -> Void in
                
                if let objects = objects as? [PFObject] {
                    Singleton.languages = objects
                }
                response(Singleton.languages)
            }
        }
    }
}