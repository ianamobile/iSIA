//
//  SearchSIADetails.swift
//  SIA
//
//  Created by Piyush Panchal on 6/21/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

class SearchSIADetailsResponse
{
    
    var searchSIADetailsArray = [SearchSIADetails]()
    
    init(_ jsonArray: NSArray?) {
        
        if jsonArray != nil
        {
            
            for tempObj in jsonArray!
            {
                
                let obj = tempObj as! [String: Any]
                let searchSIADetailsObj: SearchSIADetails = SearchSIADetails(obj)
                searchSIADetailsArray.append(searchSIADetailsObj)
            }
            
            
        }
    }
    
}


class SearchSIADetails{
    
   
    var status :String?
    var irId :Int?
    var requestTypeTitle :String?
    var irRequestType :String?
    var actionRequired :String?
    var createdDate :String?
    var contNum:String?
    var bookingNum :String?
    var epCompanyName :String?
    var epScacs :String?
    var mcACompanyName :String?
    var mcAScac :String?
    var mcBCompanyName :String?
    var mcBScac :String?
    var actionDate :String?
    typealias vu = ValidationUtils
    
    init() {
        
    }
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.irId = jsonDictionary["irId"] as? Int
            self.status = jsonDictionary["status"] as? String ?? ""
            
            let intchgType = jsonDictionary["intchgType"] as? String
            if intchgType == nil || intchgType == "" || intchgType == "null"  || vu.isEmptyString(stringToCheck: intchgType!){
                self.requestTypeTitle = "STREET TURN"
                self.irRequestType = "StreetTurn"
            }else {
                self.requestTypeTitle = " STREET INTERCHANGE"
                self.irRequestType = "StreetInterchange"
            }
            
            self.actionRequired       = jsonDictionary["actionRequired"] as? String
            self.createdDate   = jsonDictionary["createdDate"] as? String
            self.contNum    = jsonDictionary["contNum"] as? String
            self.bookingNum   = jsonDictionary["bookingNum"] as? String
            self.epCompanyName    = jsonDictionary["epCompanyName"] as? String
            self.epScacs       = jsonDictionary["epScacs"] as? String
            
            self.mcACompanyName = jsonDictionary["mcACompanyName"] as? String
            self.mcAScac       = jsonDictionary["mcAScac"] as? String
            self.mcBCompanyName   = jsonDictionary["mcBCompanyName"] as? String
            self.mcBScac    = jsonDictionary["mcBScac"] as? String
            self.actionDate = jsonDictionary["modifiedDate"] as? String ?? ""
            
        }
    }
    
    
}

