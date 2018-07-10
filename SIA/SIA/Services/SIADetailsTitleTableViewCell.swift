//
//  SIADetailsTitleTableViewCell.swift
//  DetailsPageViewProject
//
//  Created by Piyush Panchal on 6/7/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SIADetailsTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var leftView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.numberOfLines = 0
        lblTitle.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
