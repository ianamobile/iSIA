//
//  ViewWorkFlowTableViewCell.swift
//  SIA
//
//  Created by Piyush Panchal on 7/13/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class ViewWorkFlowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var downArrowImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
