//
//  DashboardTableViewCell.swift
//  AnimatedMenu
//
//  Created by Piyush Panchal on 5/25/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var leftView: CardView!
    @IBOutlet weak var leftTopImage: UIImageView!
    @IBOutlet weak var leftCircleView: CircleView!
    @IBOutlet weak var leftCircleViewImage: UIImageView!
    @IBOutlet weak var leftViewSeparator: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftBottomImage: UIImageView!
    
    @IBOutlet weak var rightView: CardView!
    @IBOutlet weak var rightTopImage: UIImageView!
    @IBOutlet weak var rightCircleView: CircleView!
    @IBOutlet weak var rightCircleViewImage: UIImageView!
    @IBOutlet weak var rightViewSeparator: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var rightBottomImage: UIImageView!
    
    weak var delegate: DashboardTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let leftViewTap = UITapGestureRecognizer(target: self, action: #selector(self.leftViewTapDetected))
        leftView.addGestureRecognizer(leftViewTap)
        
        let rightViewTap = UITapGestureRecognizer(target: self, action: #selector(self.rightViewTapDetected))
        rightView.addGestureRecognizer(rightViewTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func leftViewTapDetected() {
       delegate?.findAndNavigateToTappedView(sender: self, originFrom: "left")
    }
    @objc func rightViewTapDetected() {
       delegate?.findAndNavigateToTappedView(sender: self, originFrom: "right")
    }
    
    func hideRightMenu(){
       rightView.alpha = 0
    }
    

}
