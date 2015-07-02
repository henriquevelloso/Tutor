//
//  VideoCallViewController.swift
//  
//
//  Created by Henrique Velloso on 6/26/15.
//
//

import UIKit



class VideoCallViewController: UIViewController , QBRTCClientDelegate {

    var session : QBRTCSession?;
    let kOpponentCollectionViewCellIdentifier = "OpponentCollectionViewCellIdentifier"
    var userIDToCall : String?
    
    
    @IBOutlet weak var videoCallFull: QBGLVideoView!
    @IBOutlet weak var videoCallSelfie: QBGLVideoView!
    
    @IBOutlet weak var btnMicrofone: UIButton!
    @IBOutlet weak var btnEndCall: UIButton!
    @IBOutlet weak var btnChangeCam: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        

        
       // var caller: QBUUser  = [ConnectionManager.instance userWithID:self.session.callerID];
       // [ConnectionManager.instance.me isEqual:caller] ? [self startCall] : [self acceptCall];
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    //Call
    
    
    func callUser(userID:String)
    {
        if self.session != nil {
            return
        }
        
        QBSoundRouter.instance().initialize()
        
        
        var opponents:NSArray = [userID]
        
        var sessionLocal = QBRTCClient.instance().createNewSessionWithOpponents(opponents as [AnyObject], withConferenceType: QBConferenceType.Video)
        
        if sessionLocal != nil {
        
            self.session = sessionLocal
            
            
        }
        
        
    }
    
    

}
