//
//  UserDetails.swift
//  BOES
//
//  Created by Piyush Panchal on 8/7/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import Foundation

class UserDetails{

    var uiiaAcctNo:String?
    var scac :String?
    var companyName :String?
    var userName :String?
    var role :String?
    var userId  :Int?
    var memType:String?
    var tpuEpScac:String?
    var iddPin :String?
    var driverLicenseNumber :String?
    var driverLicenseState :String?
    
    var configDetailsSetFlag:Bool?
    
    var email :String?
    var firstName :String?
    var lastName :String?
    var accessToken:String?
    var originFrom :String?
    var iniIntrchng: String?;
    var iniIntrchngAndApprove:String?;
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            self.uiiaAcctNo = jsonDictionary["uiiaAcctNo"] as? String
            self.scac = jsonDictionary["scac"] as? String
            self.companyName = jsonDictionary["companyName"] as? String
            self.userName = jsonDictionary["userName"] as? String
            self.role = jsonDictionary["roleName"] as? String
            self.userId  = jsonDictionary["sipId"] as? Int
            self.memType = jsonDictionary["memType"] as? String
            self.tpuEpScac = jsonDictionary["tpuEpScac"] as? String
            
            self.iddPin = jsonDictionary["iddPin"] as? String
            self.driverLicenseNumber = jsonDictionary["drvLicenseNo"] as? String
            self.driverLicenseState = jsonDictionary["drvLicenseState"] as? String
            
            self.configDetailsSetFlag = jsonDictionary["configDetailsSetFlag"] as? Bool
            
            self.email = jsonDictionary["email"] as? String
            self.firstName = jsonDictionary["fname"] as? String
            self.lastName = jsonDictionary["lname"] as? String
            
            self.accessToken = jsonDictionary["accessToken"] as? String
            
            if( role == "SEC"){
                let permissions:[String: Any] = (jsonDictionary["permissions"] as? [String: Any])!
                self.iniIntrchng = permissions["iniIntrchng"] as? String
                self.iniIntrchngAndApprove =  permissions["iniIntrchngAndApprove"] as? String
            }
           
            
        }
    }
     
     
     
  
    
    
    
}
