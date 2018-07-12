//
//  UIIAExhibitTableViewCell.swift
//  SIA
//
//  Created by Piyush Panchal on 7/12/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

import UIKit

class UIIAExhibitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblFieldName: UILabel!
    @IBOutlet weak var lblFieldData: UILabel!
    @IBOutlet weak var checkBoxLabel: UILabel!
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
