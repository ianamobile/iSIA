//
//  UITextFieldExtension.swift
//  BOES
//
//  Created by Piyush Panchal on 8/12/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import UIKit
import Foundation


extension UITextField {
    func setBottomBorder() {
        
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    class func connectFields(fields:[UITextField]) -> Void {
        guard let last = fields.last else {
            return
        }
        for i in 0 ..< fields.count - 1 {
            fields[i].returnKeyType = .next
            fields[i].addTarget(fields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        last.returnKeyType = .go
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(paste(_:))) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    
     
}
