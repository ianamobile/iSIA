//
//  CircleView.swift
//  AnimatedMenu
//
//  Created by Piyush Panchal on 5/22/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

@IBDesignable class CircleView: UIView {

    override func layoutSubviews() {
      // super.layoutSubviews()
        layer.cornerRadius = bounds.size.width / 2
        layer.masksToBounds = true
    }

}
