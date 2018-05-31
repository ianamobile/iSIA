//
//  CardView.swift
//  AnimatedMenu
//
//  Created by Piyush Panchal on 5/22/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
 
    @IBInspectable var cornerradious : CGFloat = 2
    @IBInspectable var shadowOffsetWidth : CGFloat = 0
    @IBInspectable var shadowOffsetHeight : CGFloat = 1
    @IBInspectable var shadowColor : UIColor = UIColor.black
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    //@IBInspectable var enableShadow : Bool = true
    
    override func layoutSubviews() {
       
        //if(enableShadow){
        
            layer.cornerRadius = cornerradious
            layer.shadowColor = shadowColor.cgColor
            layer.shadowOffset  = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradious)
            layer.shadowPath = shadowPath.cgPath
            
            layer.shadowOpacity = Float(shadowOpacity)
        //}
      
        
    }
    
    func setToDefault() {
        //print("default")
        //enableShadow = false
        layer.cornerRadius = 0
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(0)
        
    }
    
}
