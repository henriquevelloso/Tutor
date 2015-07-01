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
    dynamic var currentLang : PFObject?
    
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
    
    func getHistory(response: (NSArray!)->())
    {
        if let user = self.parseUser
        {
            var counter : Int = 0
            var queryResult : NSMutableArray = NSMutableArray()
            let finalize : ([AnyObject]?) -> ()  = {
                result in
                
                if let result = result{
                    queryResult.addObjectsFromArray(result)
                }
                
                if (counter++ > 0)
                {
                    response(queryResult)
                    self.getHistoryForWatchKit(queryResult)
                }
            }
            
            let madeCallQuery : PFQuery = PFQuery(className: "CallHistory")
            madeCallQuery.includeKey("MadeCall")
            madeCallQuery.includeKey("ReceivedCall")
            
            madeCallQuery.whereKey("MadeCall", equalTo: user)
            madeCallQuery.orderByDescending("createdAt")
            madeCallQuery.limit = 15
            
            madeCallQuery.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
                finalize(result)
            })
            
            
            let receivedCallQuery : PFQuery = PFQuery(className: "CallHistory")
            receivedCallQuery.includeKey("MadeCall")
            receivedCallQuery.includeKey("ReceivedCall")
            
            receivedCallQuery.whereKey("ReceivedCall", equalTo: user)
            receivedCallQuery.orderByDescending("createdAt")
            receivedCallQuery.limit = 15
            
            receivedCallQuery.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
                finalize(result)
            })


        }
    }

    func getHistoryForWatchKit(allHistory : NSArray!)
    {
        let data = NSMutableArray()
        
        var access = 0
        let undoaccess : () -> () = {
            if --access < 0
            {
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: "history")
            }
        }
        let doaccess : () -> () = {
            access++
        }
        
        
        for callHistory in allHistory
        {
            let historyArray = NSMutableArray()
            let history = CallHistory(callHistory: callHistory as! PFObject)
            
            let madeUser = User()
            if let userMade = history.madeCall
            {
                madeUser.loadData(userMade)
            }
            
            let receivedUser = User()
            if let userReceived = history.receivedCall
            {
                receivedUser.loadData(userReceived)
            }
            if let duration = history.callDuration
            {
                historyArray.addObject("\(duration)")
            }
            
            let fillUserData : (User) -> () = {
                user in
                
                doaccess()
                user.getPhoto({ (photoData, error) -> () in
                    if let photoData = photoData
                    {
                        historyArray.addObject(photoData)
                        undoaccess()
                    }
                })
                
                if let userName = user.name
                {
                    historyArray.addObject(userName)
                }
            }
            
            if let idCurrentUser = User.user.parseUser?.objectId
            {
                if let idReceived = receivedUser.parseUser?.objectId
                {
                    if idCurrentUser == idReceived
                    {
                        fillUserData(madeUser)
                    }else{
                        fillUserData(receivedUser)
                    }
                }else if let idMade = madeUser.parseUser?.objectId
                {
                    if idCurrentUser == idMade
                    {
                        fillUserData(receivedUser)
                    }else{
                        fillUserData(madeUser)
                    }
                }
                
            }
            data.addObject(historyArray)
        }
        undoaccess()
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
