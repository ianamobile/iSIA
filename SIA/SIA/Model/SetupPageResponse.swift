//
//  SetupPageResponse.swift
//  SIA
//
//  Created by Piyush Panchal on 7/4/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

class SetupPageResponse {
    
    var contTypeArray = [String]()
    var contSizeArray = [String]()
    var chassisTypeArray = [String]()
    var chassisSizeArray = [String]()
    
    init(_ data: [String : Any]) {
        
        if let jsonArray:NSArray   = data["contTypeList"] as? NSArray
        {
                for tempObj in jsonArray
                {
                    
                    let obj = tempObj as! [String: Any]
                    let fieldDetailsObj: FieldDetails = FieldDetails(obj)
                    contTypeArray.append(fieldDetailsObj.value!)
                    
                }
            
        }
        if let jsonArray:NSArray   = data["contSizeList"] as? NSArray
        {
            
            for tempObj in jsonArray
            {
                
                let obj = tempObj as! [String: Any]
                let fieldDetailsObj: FieldDetails = FieldDetails(obj)
                contSizeArray.append(fieldDetailsObj.value!)
               
            }
                
                
            
        }
        
        if let jsonArray:NSArray   = data["chassisTypeList"] as? NSArray
        {
            for tempObj in jsonArray
            {
                
                let obj = tempObj as! [String: Any]
                let fieldDetailsObj: FieldDetails = FieldDetails(obj)
                chassisTypeArray.append(fieldDetailsObj.value!)
            }
        }
        
        if let jsonArray:NSArray   = data["chassisSizeList"] as? NSArray
        {
            for tempObj in jsonArray
            {
                
                let obj = tempObj as! [String: Any]
                let fieldDetailsObj: FieldDetails = FieldDetails(obj)
                chassisSizeArray.append(fieldDetailsObj.value!)
                
            }
        }
        
        
    }
    
}


class FieldDetails{
    
    var id :Int!
    var value :String?
    
    init() {
        
    }
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            self.id       = jsonDictionary["id"] as! Int
            self.value    = jsonDictionary["value"] as? String
        }
    }
    
    
}

