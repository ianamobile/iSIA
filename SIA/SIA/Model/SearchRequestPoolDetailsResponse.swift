//
//  File.swift
//  SIA
//
//  Created by Piyush Panchal on 7/4/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

class SearchRequestPoolDetailsResponse
{
    
    var searchRequestPoolDetailsArray = [SearchRequestPoolDetails]()
    
    init(_ jsonArray: NSArray?) {
        
        if jsonArray != nil
        {
            
            for tempObj in jsonArray!
            {
                
                let obj = tempObj as! [String: Any]
                let searchRequestPoolDetailsObj: SearchRequestPoolDetails = SearchRequestPoolDetails(obj)
                searchRequestPoolDetailsArray.append(searchRequestPoolDetailsObj)
            }
            
            
        }
    }
    
}


class SearchRequestPoolDetails{
    
    var naId :Int!
    var sipId :String?
    var mcCompanyName :String?
    var epCompanyName :String?
    var mcScac :String?
    var epScac :String?
    var loadStatus :String?
    var contNum :String?
    var contSize :String?
    var contType :String?
    var chassisSize :String?
    var chassisType :String?
    var chassisNum :String?
    var gensetNum :String?
    var equipLocSplcCode :String?
    var equipLocIanaCode :String?
    var equipLocNm :String?
    var equipLocAddr :String?
    var equipLocCity :String?
    var equipLocState :String?
    var equipLocZip :String?
    var originLocSplcCode :String?
    var originLocIanaCode :String?
    var originLocNm :String?
    var originLocAddr :String?
    var originLocCity :String?
    var originLocState :String?
    var originLocZip :String?
    var iepScac :String?
    var createdDate :String?
    var showDeleteBtn:String?
    
   
    init() {
        
    }
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            self.naId       = jsonDictionary["naId"] as! Int
            self.sipId   = jsonDictionary["sipId"] as? String
            self.mcCompanyName = jsonDictionary["mcCompanyName"] as? String
            self.mcScac       = jsonDictionary["mcScac"] as? String
            self.epCompanyName    = jsonDictionary["epCompanyName"] as? String
            self.epScac       = jsonDictionary["epScac"] as? String
            self.loadStatus       = jsonDictionary["loadStatus"] as? String
            self.contNum    = jsonDictionary["contNum"] as? String
            self.contSize       = jsonDictionary["contSize"] as? String
            self.contType       = jsonDictionary["contType"] as? String
            self.chassisSize       = jsonDictionary["chassisSize"] as? String
            self.chassisType       = jsonDictionary["chassisType"] as? String
            self.chassisNum       = jsonDictionary["chassisNum"] as? String
            self.gensetNum       = jsonDictionary["gensetNum"] as? String
            self.iepScac       = jsonDictionary["iepScac"] as? String
            self.equipLocSplcCode   = jsonDictionary["equipLocSplcCode"] as? String
            self.equipLocIanaCode    = jsonDictionary["equipLocIanaCode"] as? String
            self.equipLocNm = jsonDictionary["equipLocNm"] as? String ?? ""
            self.equipLocAddr   = jsonDictionary["equipLocAddr"] as? String
            self.equipLocCity    = jsonDictionary["equipLocCity"] as? String
            self.equipLocState = jsonDictionary["equipLocState"] as? String ?? ""
            self.equipLocZip = jsonDictionary["equipLocZip"] as? String ?? ""
            self.originLocSplcCode   = jsonDictionary["originLocSplcCode"] as? String
            self.originLocIanaCode    = jsonDictionary["originLocIanaCode"] as? String
            self.originLocNm = jsonDictionary["originLocNm"] as? String ?? ""
            self.originLocAddr   = jsonDictionary["originLocAddr"] as? String
            self.originLocCity    = jsonDictionary["originLocCity"] as? String
            self.originLocState = jsonDictionary["originLocState"] as? String ?? ""
            self.originLocZip = jsonDictionary["originLocZip"] as? String ?? ""
            self.createdDate   = jsonDictionary["createdDate"] as? String
            self.showDeleteBtn = jsonDictionary["showDeleteBtn"] as?String ?? "N"
            
            
        }
    }
    
    
}

