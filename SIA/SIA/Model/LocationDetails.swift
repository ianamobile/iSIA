//
//  LocationDetails.swift
//  DVIR
//
//  Created by Piyush Panchal on 2/2/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

class LocationDetails {
    
    var ianaLocationInfoArray = [IANALocationInfo]()
    
    init(_ jsonArray: NSArray?) {
        
        if jsonArray != nil
        {
            
            for tempLocationObj in jsonArray!
            {
                
                let obj = tempLocationObj as! [String: Any]
                let ianaLocationInfo: IANALocationInfo = IANALocationInfo(obj)
                ianaLocationInfoArray.append(ianaLocationInfo)
            }
            
            
        }
    }
    
    
    
}


class IANALocationInfo{
    
    var ianaCode :String?
    var splcCode :String?
    var address :String?
    var facilityName :String?
    var zip :String?
    var city :String?
    var state :String?
    
    init() {
        
    }
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.ianaCode = jsonDictionary["ianaCode"] as? String
            self.splcCode       = jsonDictionary["splcCode"] as? String
            self.facilityName   = jsonDictionary["locName"] as? String
            self.address    = jsonDictionary["addr"] as? String
            self.zip    = jsonDictionary["zip"] as? String
            self.city    = jsonDictionary["city"] as? String
            self.state    = jsonDictionary["state"] as? String
            
        }
    }
    
    
}
