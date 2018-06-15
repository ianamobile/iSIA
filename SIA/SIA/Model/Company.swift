//
//  Company.swift
//  SIA
//
//  Created by Piyush Panchal on 6/12/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

class Company {
    
    var companyInfoArray = [CompanyInfo]()
    
    init(_ jsonArray: NSArray?) {
        
        if jsonArray != nil
        {
            
            for tempLocationObj in jsonArray!
            {
                
                let obj = tempLocationObj as! [String: Any]
                let companyInfo: CompanyInfo = CompanyInfo(obj)
                companyInfoArray.append(companyInfo)
            }
            
            
        }
    }
    
    
    
}


class CompanyInfo{
    
    var companyName :String?
    var scac :String?
    init() {
        
    }
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.companyName = jsonDictionary["companyName"] as? String
            self.scac       = jsonDictionary["scac"] as? String
            
        }
    }
    
    
}
