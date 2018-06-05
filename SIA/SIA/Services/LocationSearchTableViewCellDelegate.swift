//
//  LocationSearchTableViewCellDelegate.swift
//  SIA
//
//  Created by Piyush Panchal on 5/31/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

protocol LocationSearchTableViewCellDelegate: class {
    func findAndNavigateToTappedView(selectedLocation: IANALocationInfo, originFrom: String)
}

