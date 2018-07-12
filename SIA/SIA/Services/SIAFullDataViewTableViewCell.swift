//
//  SIAFullDataViewTableViewCell.swift
//  SIA
//
//  Created by Piyush Panchal on 7/11/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SIAFullDataViewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblFieldData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblFieldData.numberOfLines = 0
        lblFieldData.sizeToFit()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
         
    }
    
}
