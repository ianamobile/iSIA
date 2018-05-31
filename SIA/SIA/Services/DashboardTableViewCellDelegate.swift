//
//  DashboardTableViewCellDelegate.swift
//  SIA
//
//  Created by Piyush Panchal on 5/28/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

protocol DashboardTableViewCellDelegate: class {
    func findAndNavigateToTappedView(sender: DashboardTableViewCell, originFrom: String)
}
