//
//  UIIAExhibit.swift
//  SIA
//
//  Created by Piyush Panchal on 7/12/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

class UIIAExhibitResponse
{
    
    var uiiaExhibitArray = [UIIAExhibit]()
    
    init(_ jsonArray: NSArray?) {
        
        if jsonArray != nil
        {
            
            for tempObj in jsonArray!
            {
                
                let obj = tempObj as! [String: Any]
                let uiiaExhibitObj: UIIAExhibit = UIIAExhibit(obj)
                uiiaExhibitArray.append(uiiaExhibitObj)
            }
            
            
        }
    }
    
}


class UIIAExhibit{
    
    var ueId :Int?
    var item : String?
    var itemNo : String?
    var itemDesc : String?
    
    init() {
        
    }
    
    init(_ data: [String : Any]) {
        
        self.ueId =  data["ueId"] as? Int
        self.item =  data["item"] as? String
        self.itemNo =  data["itemNo"] as? String
        self.itemDesc =  data["itemDesc"] as? String
        
    }
    
}

