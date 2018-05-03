//
//  SearchDVIRDetailsResponse.swift
//  DVIR
//
//  Created by Piyush Panchal on 2/14/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation


class SearchDVIRDetailsResponse
{
    
    var searchDVIRDetailsArray = [SearchDVIRDetails]()
    
    init(_ jsonArray: NSArray?) {
        
        if jsonArray != nil
        {
            
            for tempObj in jsonArray!
            {
                
                let obj = tempObj as! [String: Any]
                let searchDVIRDetailsObj: SearchDVIRDetails = SearchDVIRDetails(obj)
                searchDVIRDetailsArray.append(searchDVIRDetailsObj)
            }
            
            
        }
    }
    
}


class SearchDVIRDetails{
    
    var dvirNo:String?
    var tranDate :String?
    var tranTimeHr :String?
    var chassisNum :String?
    var mcScac :String?
    var mcName :String?
    var mcDot :String?
    var status :String?
    
    var iepDot :String?
    var iepName :String?
    var drvName :String?
    var driverLic :String?
    var licState :String?
    var iddPin :String?
    var rcdString :String?
    
    init() {
        
    }
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.dvirNo = jsonDictionary["dvirNo"] as? String
            self.tranDate = jsonDictionary["tranDate"] as? String
            self.tranTimeHr       = jsonDictionary["tranTimeHr"] as? String
            self.chassisNum   = jsonDictionary["chassisNum"] as? String
            self.mcScac    = jsonDictionary["mcScac"] as? String
            self.mcName   = jsonDictionary["mcName"] as? String
            self.mcDot    = jsonDictionary["mcDot"] as? String
            self.status       = jsonDictionary["status"] as? String
            
            self.iepDot = jsonDictionary["iepDot"] as? String
            self.iepName       = jsonDictionary["iepName"] as? String
            self.drvName   = jsonDictionary["drvName"] as? String
            self.driverLic    = jsonDictionary["driverLic"] as? String
            self.licState   = jsonDictionary["licState"] as? String
            self.iddPin    = jsonDictionary["iddPin"] as? String
            self.rcdString       = jsonDictionary["rcdString"] as? String
            
            
        }
    }
    
    
}
