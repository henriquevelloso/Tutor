//
//  User.swift
//  
//
//  Created by Matheus Oliveira Rabelo on 6/25/15.
//
//

import UIKit

class User: NSObject {
    static let user = User()    // User singleton
    
    var parseUser : PFUser?
    
    var fbID : String?
    var name : String?
    var email : String?
    var gender : String?
    
    var photo : NSData?
    
    var nativeLang : PFObject?
    var currentLang : PFObject?
    
    func getNativeLanguage(response: (PFObject?) -> ())
    {
        if let native = self.nativeLang {
            response(native)
        }else{
            if let user = self.parseUser
            {
                if let langObjID = user.objectForKey("NativeLanguage")?.objectId
                {
                    let query = PFQuery(className: "Language")
                    
                    query.getObjectInBackgroundWithId(langObjID!, block: { (lang, error) -> Void in
                        if let lang = lang
                        {
                            self.nativeLang = lang
                        }
                        response(self.nativeLang)
                    })
                    
                }
            }
        }
    }
    func getCurrentLanguage(response: (PFObject?) -> ())
    {
        if let current = currentLang
        {
            response(current)
        }else{
            
            if let user = self.parseUser
            {
                if let langObjID = user.objectForKey("PracticeLanguage")?.objectId
                {
                    let query = PFQuery(className: "Language")
                    
                    query.getObjectInBackgroundWithId(langObjID!, block: { (lang, error) -> Void in
                        if let lang = lang
                        {
                            self.currentLang = lang
                        }
                        response(self.currentLang)
                    })
                    
                }
            }
        }
    }
    
    func getPhoto(response:(NSData?, NSError?)->())
    {
        if let photo = photo
        {
            response(photo, nil)
        }else{
            if let parseUser = parseUser{
                let photoFile : PFFile? = parseUser.objectForKey("image") as? PFFile
                if let photoFile = photoFile
                {
                    photoFile.getDataInBackgroundWithBlock({ (photoData, error) -> Void in
                        self.photo = photoData
                        response(photoData, error)
                    })
                }
            }else{
                response(nil, nil)
            }
        }
    }
    
    func loadData(puser: PFUser){
        self.parseUser = puser
        
        self.fbID = puser.objectForKey("facebookId") as? String
        self.name = puser.objectForKey("name") as? String
        self.gender = puser.objectForKey("gender") as? String
        self.email = puser.email
        
        let query : PFQuery = PFQuery()
        query.includeKey("PracticeLanguage")
        query.includeKey("NativeLanguage")
        
        
        self.getPhoto { (photoData, error) -> () in
            // nil
        }
    }
    func saveWithBlock(response:(Bool, NSError?)->()){
        if let user = parseUser{
            if let email = self.email
            {
                user.email = email
            }
            
            if let fbID = self.fbID
            {
                user.setObject(fbID, forKey: "facebookId")
            }
            if let name = self.name
            {
                user.setObject(name, forKey: "name")
            }
            if let gender = self.gender
            {
                user.setObject(gender, forKey: "gender")
            }
            
            
            if let photo = self.photo
            {
                user.setObject(PFFile(name: "default.jpeg", data: photo), forKey: "image")
            }
            
            user.saveInBackgroundWithBlock({ (successed, error) -> Void in
                response(successed, error)
            })
        }
    }
}
