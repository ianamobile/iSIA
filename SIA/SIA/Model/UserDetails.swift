//
//  UserDetails.swift
//  BOES
//
//  Created by Piyush Panchal on 8/7/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import Foundation

class UserDetails {
    
   
    
    var userName :String?
    var role :String?
    var scac :String?
    var headerName :String?
    var companyName :String?
    var email :String?
    var firstName :String?
    var lastName :String?
    var userId  :Int?
    var accessToken:String?
    
    var iddPin :String?
    var driverLicenseNumber :String?
    var driverLicenseState :String?
    var originFrom :String?
    
    
   
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.userName = jsonDictionary["userName"] as? String
            self.role = jsonDictionary["role"] as? String
            self.scac = jsonDictionary["scac"] as? String
            self.headerName = jsonDictionary["headerName"] as? String
            self.companyName = jsonDictionary["companyName"] as? String
            self.email = jsonDictionary["email"] as? String
            self.firstName = jsonDictionary["firstName"] as? String
            self.lastName = jsonDictionary["lastName"] as? String
            self.userId  = jsonDictionary["userId"] as? Int
            self.accessToken = jsonDictionary["accessToken"] as? String
            
            
            
        }
    }
     
     
     
  
    
    
    
}
