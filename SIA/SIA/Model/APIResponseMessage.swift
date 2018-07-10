//
//  APIResponseMessage.swift
//  BOES
//
//  Created by Piyush Panchal on 8/11/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import Foundation


class APIResponseMessage {
    
    var code:Int?
    var type :String?
    var message :String?
    var errors: Errors = Errors()
    
    /* var apiReqErrors :[String : [String:[Errors]]]? */
    
    init(_ jsonDictionary:[String: Any]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.code = jsonDictionary["code"] as? Int
            self.type = jsonDictionary["type"] as? String
            self.message   = jsonDictionary["message"] as? String
            
            if(self.type == "error" && self.code == 1){
                
                if let apiReqErrors : [String: Any] = jsonDictionary["apiReqErrors"] as? [String : Any]{
                    
                    let jsonErrorArray : NSArray? =  apiReqErrors["errors"] as? NSArray
                    if jsonErrorArray != nil {
                        var i: Int = 0
                        for tempErrors in jsonErrorArray! where i == 0
                        {
                            
                            let errorsObj = tempErrors as! [String: Any]
                            errors.errorMessage = errorsObj["errorMessage"] as? String
                            i = i + 1
                        }
                        
                    }
                }
                
                
            }
            
            
            
            
          
            
        }
    }
    
}

class Errors{
    
    var transNum:Int?
    var errorCategory :String?
    var errorMessage :String?
    
    
    
}

