//
//  OriginalLocationSearchTableViewCell.swift
//  SIA
//
//  Created by Piyush Panchal on 6/1/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class OriginalLocationSearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftColoredView: UIView!
    
    @IBOutlet weak var lblSplcCode: UILabel!
    @IBOutlet weak var lblIanaCode: UILabel!
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblZipCode: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblLocationName.numberOfLines = 0;
        lblLocationName.sizeToFit()
        
        lblAddress.numberOfLines = 0
        lblAddress.sizeToFit()
        //set up the UI
        leftColoredView.roundCorners([.topRight, .bottomRight], radius: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }

}
