//
//  Profile.swift
//  SIA
//
//  Created by Piyush Panchal on 6/22/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation


class ProfileResponse{
    
    var epUsersArray = [Profile]()
    
    init(_ jsonArray: NSArray?) {
        
        if jsonArray != nil
        {
            
            for tempObj in jsonArray!
            {
                
                let obj = tempObj as! [String: Any]
                let epUserObj: Profile = Profile(obj)
                epUsersArray.append(epUserObj)
            }
            
            
        }
    }
    
}

class Profile
{
    

    var sipId :Int?
    var companyName :String?
    var scac :String?
    var uiiaAcctNo :String?
    var status :String?
    
    init() {
        
    }
    
    init(sipId:Int, companyName:String, scac: String, uiiaAcctNo:String ,status:String) {
        self.sipId = sipId
        self.companyName = companyName
        self.scac = scac
        self.uiiaAcctNo = uiiaAcctNo
        self.status = status
    }
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            self.sipId = jsonDictionary["sipId"] as? Int
            self.companyName = jsonDictionary["companyName"] as? String
            self.scac = jsonDictionary["scac"] as? String
            self.uiiaAcctNo = jsonDictionary["uiiaAcctNo"] as? String
            self.status = jsonDictionary["status"] as? String
            
        }
    }
   
}
