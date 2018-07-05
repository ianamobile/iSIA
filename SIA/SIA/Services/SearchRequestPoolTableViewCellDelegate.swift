//
//  SearchRequestPoolTableViewCellDelegate.swift
//  SIA
//
//  Created by Piyush Panchal on 7/4/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

protocol SearchRequestPoolTableViewCellDelegate: class {
    func deleteNotificationAvailRecord(sender: SearchRequestPoolTableViewCell, originFrom: String)
}



