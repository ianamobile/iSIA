//
//  SearchRequestPoolTableViewCell.swift
//  SIA
//
//  Created by Piyush Panchal on 7/4/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SearchRequestPoolTableViewCell: UITableViewCell {

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var lblMCCompanyName: UILabel!
    @IBOutlet weak var lblMCScac: UILabel!
    @IBOutlet weak var lblEPName: UILabel!
    @IBOutlet weak var lblEPScac: UILabel!
    @IBOutlet weak var loadStatus: UILabel!
    @IBOutlet weak var lblContNum: UILabel!
    @IBOutlet weak var lblContType: UILabel!
    @IBOutlet weak var lblContSize: UILabel!
    @IBOutlet weak var lblChassisType: UILabel!
    @IBOutlet weak var lblChassisSize: UILabel!
    @IBOutlet weak var lblChasisNum: UILabel!
    @IBOutlet weak var lblIEPScac: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    weak var delegate: SearchRequestPoolTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteNotificationAvailRecord(sender: self, originFrom: "");
    }
}
