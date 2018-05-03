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
    
    var splcId:String?
    var ianaCode :String?
    var splcCode :String?
    var facilityName :String?
    var state :String?
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.splcId = jsonDictionary["splcId"] as? String
            self.ianaCode = jsonDictionary["ianaCode"] as? String
            self.splcCode       = jsonDictionary["splcCode"] as? String
            self.facilityName   = jsonDictionary["facilityName"] as? String
            self.state    = jsonDictionary["state"] as? String
            
        }
    }
    
    
}
