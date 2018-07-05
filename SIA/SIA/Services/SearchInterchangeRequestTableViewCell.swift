//
//  SearchInterchangeRequestTableViewCell.swift
//  SIA
//
//  Created by Piyush Panchal on 6/21/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SearchInterchangeRequestTableViewCell: UITableViewCell {

   
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var lblRequestType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblActionRequired: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    @IBOutlet weak var lblContNum: UILabel!
    @IBOutlet weak var lblExportBookingNum: UILabel!
    @IBOutlet weak var lblEPName: UILabel!
    @IBOutlet weak var lblEPScac: UILabel!
    @IBOutlet weak var lblMCAName: UILabel!
    @IBOutlet weak var lblMCAScac: UILabel!
    @IBOutlet weak var lblMCBName: UILabel!
    @IBOutlet weak var lblMCBScac: UILabel!
    @IBOutlet weak var lblActionDateTitle: UILabel!
    @IBOutlet weak var lblActionDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
