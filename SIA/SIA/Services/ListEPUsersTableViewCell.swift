//
//  ListEPUsersTableViewCell.swift
//  SIA
//
//  Created by Piyush Panchal on 6/22/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class ListEPUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEPName: UILabel!
    @IBOutlet weak var lblSCAC: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var actionImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
