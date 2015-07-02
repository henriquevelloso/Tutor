//
//  QuickBloxManager.swift
//  
//
//  Created by Henrique Velloso on 6/26/15.
//
//

import UIKit


  class QuickBloxManager: NSObject , QBChatDelegate {
    
    let kQBRingThickness = 1
    let kQBAnswerTimeInterval : NSTimeInterval = 60
    let kQBRTCDisconnectTimeInterval : NSTimeInterval = 30
    
    let kQBApplicationID : UInt = 24773
    let kQBRegisterServiceKey = "UuyLbWCg3WQsf-Q"
    let kQBRegisterServiceSecret = "4mNC-yRSXwGQC7E"
    let kQBAccountKey = "mZ5jzqWW1kdSzzBGXzAy"
    
    var currentUser : QBUUser?
   
    
    class var sharedInstance : QuickBloxManager {
        struct Static {
            static let instance : QuickBloxManager = QuickBloxManager()
        }
        return Static.instance
    }

    
    func configQuickBlox() {
        
        
        //Quickblox preferences
        QBApplication.sharedApplication().applicationId = kQBApplicationID
        QBConnection.registerServiceKey(kQBRegisterServiceKey);
        QBConnection.registerServiceSecret(kQBRegisterServiceSecret);
        QBSettings.setAccountKey(kQBAccountKey);
        QBSettings.setLogLevel(QBLogLevel.Debug);
        
        //QuickbloxWebRTC preferences
        QBRTCConfig.setAnswerTimeInterval(kQBAnswerTimeInterval);
        QBRTCConfig.setDisconnectTimeInterval(kQBRTCDisconnectTimeInterval);
        QBRTCConfig.setDialingTimeInterval(5)
        
        self.createSession()
        
    }
    
    
    func loginUser(user:QBUUser, completion: (success: Bool) -> ()) {
        
            QBChat.instance().addDelegate(self)
        QBChat.instance().loginWithUser(user)
    
        
        if QBChat.instance().isLoggedIn() {
            completion(success: true)
        }
        else {
            completion(success: false)
        }
    }
    
    func loginUserWithID(_login:String, _password:String, completion: (success: Bool) -> ()) {
        
        QBRequest.logInWithUserLogin(_login, password: _password, successBlock: { (response:QBResponse!, user:QBUUser!) -> Void in
            
            self.currentUser = user
            println("USER LOGIN")
            
            }) { (error:QBResponse!) -> Void in
            
                println("USER ERROR --------")
        }
        
    }
    
    
    func createSession() {
        
        
        QBRequest.createSessionWithSuccessBlock({ (request:QBResponse!, session:QBASession!) -> Void in
            
            println("Session OK !!!!!!!!!!!!!!!")
            
            }, errorBlock: { (error:QBResponse!) -> Void in
            println("Session ERROR -------------")
                
        })
        
    }
    
    func createSessionWithLogin(login:String, password:String) {
        
        QBRequest.logInWithUserLogin(login, password: password, successBlock: { (response:QBResponse!, user:QBUUser!) -> Void in
            
            print(response.status)
            
                if response.status == QBResponseStatusCode.Accepted {
                    self.currentUser = user
                }
            
            }) { (error:QBResponse!) -> Void in
        
        }
        
    }
    
    func logOutCurrentSession() {
        
        QBRequest.logOutWithSuccessBlock({ (response:QBResponse!) -> Void in
            
            if response.status == QBResponseStatusCode.Accepted {
                
                self.currentUser = nil
            }
            
            }, errorBlock: { (error:QBResponse!) -> Void in
                
        })
        
        
    }
    
    
    
    func chatDidFailWithError(code: Int) {
        
        
    }
    
    func chatDidNotLogin() {
        
        
    }
    
    
    func chatDidLogin() {
        
        
    }
    
    

    
    
}
