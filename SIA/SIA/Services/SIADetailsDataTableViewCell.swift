//
//  SIADetailsDataTableViewCell.swift
//  DetailsPageViewProject
//
//  Created by Piyush Panchal on 6/7/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SIADetailsDataTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var lblFieldData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblFieldName.numberOfLines = 0
        lblFieldName.sizeToFit()
        
        lblFieldData.numberOfLines = 0
        lblFieldData.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
    }

}
