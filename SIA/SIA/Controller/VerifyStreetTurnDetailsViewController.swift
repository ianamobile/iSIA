//
//  VerifyStreetTurnDetailsViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 6/6/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class VerifyStreetTurnDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var fieldDataArr = [String]()
    var fieldTitleArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fieldTitleArr[indexPath.row] == "blank" || fieldTitleArr[indexPath.row] == "empty"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleReuseIdentifier", for: indexPath) as! SIADetailsTitleTableViewCell
            cell.lblTitle.text  = fieldDataArr[indexPath.row]
            if fieldTitleArr[indexPath.row] == "empty"{
                cell.leftView.alpha = 0
            }
            
            // Configure the cell...
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataReuseIdentifier", for: indexPath) as! SIADetailsDataTableViewCell
            cell.lblFieldName.text = fieldTitleArr[indexPath.row]
            cell.lblFieldData.text = fieldDataArr[indexPath.row]
            // Configure the cell...
            
            return cell
        }
        
    }
    
}
