//
//  ViewStreetTurnDetailsVC.swift
//  SIA
//
//  Created by Piyush Panchal on 6/21/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class ViewStreetTurnDetailsVC: UIViewController, UITableViewDataSource,
UITableViewDelegate, UIViewControllerTransitioningDelegate{

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var siaTableView: UITableView!
    @IBOutlet weak var floaty: Floaty!
    @IBOutlet weak var viewWorkFlowBtn: UIButton!
    let transition = CircularTransition()
    
    var fieldDataArr = [FieldInfo]()
    var alertTitle :String?
    var nextScreenMessage :String = ""
    var originFrom :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  siaTableView.delegate = self
       // siaTableView.dataSource = self
        
        if originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!){
            if originFrom == "StreetTurn"{
                
                alertTitle = "STREET TURN"
            }else{
                alertTitle = "STREET INTERCHANGE"
            }
        }
        
        /* Note: Please change index if you add in middle of array otherwise next screen will be disturbed */
        fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Street Interchange Details"))
        fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER NAME", fieldData: "APL Limited"))
        fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER SCAC", fieldData: "APLU"))
        fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER'S NAME", fieldData: "Tiger Cool Express LLC"))
        fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER'S SCAC", fieldData: "MSCU"))
        fieldDataArr.append(FieldInfo(fieldTitle: "IMPORT B/L", fieldData: "IMPORT0001"))
        fieldDataArr.append(FieldInfo(fieldTitle: "EXPORT BOOKING#", fieldData: "EXPORT001"))
        fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER #", fieldData: "CONT001"))
        fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS #", fieldData: "CHASSISNO001"))
        
        if vu.isNotEmptyString(stringToCheck: nextScreenMessage) && nextScreenMessage.count > 0{
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: "CMDU"))
        }else{
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: "CMDU"))
        }
        fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: ""))
        fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Equipment Location"))
        fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: "ABCD1234565"))
        fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: "ABCDE3434342ERERER"))
        fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: "391440"))
        fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: "VADODARA"))
        fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: "CA"))
        
        
        fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //17
        fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Original Interchange Location"))
        fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: "LOCATIONNAME001"))
        fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: "ADDRESS001"))
        fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: "ZIP0002"))
        fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: "VADODAR"))
        fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: "CA"))
        
        viewWorkFlowBtn.layer.cornerRadius = viewWorkFlowBtn.frame.size.width / 2
        
        floaty.buttonImage = UIImage(named: "menu")
        floaty.plusColor = UIColor.white
        floaty.buttonColor = #colorLiteral(red: 0.9294, green: 0.3961, blue: 0.2, alpha: 1) /* #ed6533 */
        //floaty.backgroundColor = UIColor(named: "ED6533")
        floaty.overlayColor = UIColor.white /* #ed6533 */
        
        floaty.addItem(title: "Approve", handler: {_ in
           // self.view.layer.backgroundColor = UIColor.blue.cgColor
        })
        floaty.addItem(title: "Cancel Request")
        floaty.addItem(title: "Reject")
        floaty.addItem(title: "On Hold")
        floaty.addItem(title: "Re-Initiate Request")
        
        floaty.items[0].buttonColor = #colorLiteral(red: 0.3608, green: 0.7216, blue: 0.3608, alpha: 1) /* #5cb85c */
        floaty.items[0].iconImageView.image = UIImage(named: "approve")
        floaty.items[0].iconImageView.tintColor = UIColor.white
        floaty.items[0].titleColor = UIColor.black
        
        floaty.items[1].buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floaty.items[1].titleColor = UIColor.black
        floaty.items[1].iconImageView.image = UIImage(named: "cancel_tab")
        floaty.items[1].iconImageView.tintColor = UIColor.white
        
        floaty.items[2].buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floaty.items[2].titleColor = UIColor.black
        floaty.items[2].iconImageView.image = UIImage(named: "reject")
        floaty.items[2].iconImageView.tintColor = UIColor.white
        
        
        floaty.items[3].buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floaty.items[3].titleColor = UIColor.black
        floaty.items[3].iconImageView.image = UIImage(named: "onhold")
        floaty.items[3].iconImageView.tintColor = UIColor.white
        
        
        floaty.items[4].buttonColor = #colorLiteral(red: 0.3569, green: 0.7529, blue: 0.8706, alpha: 1) /* #5bc0de */
        floaty.items[4].titleColor = UIColor.black
        floaty.items[4].iconImageView.image = UIImage(named: "reinitiate")
        floaty.items[4].iconImageView.tintColor = UIColor.white
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewWorkFlowDetailsVC = segue.destination as! ViewWorkFlowDetailsVC
        viewWorkFlowDetailsVC.transitioningDelegate = self
        viewWorkFlowDetailsVC.modalPresentationStyle = .custom
        
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = viewWorkFlowBtn.center
        transition.circleColor = viewWorkFlowBtn.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = viewWorkFlowBtn.center
        transition.circleColor = viewWorkFlowBtn.backgroundColor!
        
        return transition
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fieldDataArr[indexPath.row].fieldTitle == "blank" || fieldDataArr[indexPath.row].fieldTitle == "empty"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleReuseIdentifier") as! SIADetailsTitleTableViewCell
            cell.lblTitle.text  = fieldDataArr[indexPath.row].fieldData
            if fieldDataArr[indexPath.row].fieldTitle == "empty"{
                cell.leftView.alpha = 0
            }else{
               cell.leftView.alpha = 1
            }
            // Configure the cell...
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataReuseIdentifier") as! SIADetailsDataTableViewCell
            cell.lblFieldName.text = fieldDataArr[indexPath.row].fieldTitle
            cell.lblFieldData.text = fieldDataArr[indexPath.row].fieldData
            // Configure the cell...
            
            return cell
        }
        
    }
    

}
