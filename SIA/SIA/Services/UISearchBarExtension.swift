//
//  UISearchBarExtension.swift
//  SIA
//
//  Created by Piyush Panchal on 6/6/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit
import Foundation

extension UISearchBar {
    
    func addRobotoFontToSearchBar(targetSearchBar: UISearchBar?) 
    {
        let textFieldInsideSearchBar = targetSearchBar!.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.font = UIFont(name: "Roboto-Regular", size: 14.0)
        
        //UIBarButtons font in searchbar
        let uiBarButtonAttributes: NSDictionary = [NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 14.0)!]
        UIBarButtonItem.appearance().setTitleTextAttributes(uiBarButtonAttributes as? [NSAttributedStringKey : AnyObject], for: .normal)
        
        //return targetSearchBar!
    }
}
