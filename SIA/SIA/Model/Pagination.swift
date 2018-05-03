//
//  Pagination.swift
//  BOES
//
//  Created by Piyush Panchal on 11/3/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import Foundation

class Pagination {
    
    var size:Int?
    var totalElements :Int?
    var totalPages :Int?
    var currentPage :Int?
    
    
    init(_ jsonDictionary:[String: Int]) {
        
        if !jsonDictionary.isEmpty
        {
            
            self.size = jsonDictionary["size"]
            self.totalElements = jsonDictionary["totalElements"]
            self.totalPages       = jsonDictionary["totalPages"]
            self.currentPage   = jsonDictionary["currentPage"]
            
            
        }
    }
    
    
}

