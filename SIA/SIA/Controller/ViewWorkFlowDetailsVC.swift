//
//  ViewWorkFlowDetailsVC.swift
//  SIA
//
//  Created by Piyush Panchal on 6/21/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class ViewWorkFlowDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var workFlowTable: UITableView!
    
    var workFlowDisplayArray = [WorkFlowDisplay]()
    var res: GetInterChangeRequestDetails = GetInterChangeRequestDetails() //stored interchange request response to this variable.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workFlowTable.delegate = self
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
        
        if res.workFlowList.count > 0{
            
            var wfStatusIndex :Int = 0
            for wf :WorkFlow in res.workFlowList{
                let wfDisplay =  WorkFlowDisplay()
                
                if wf.status != nil && (wf.status == "ONHOLD" || wf.status == "REJECTED" || wf.status == "CANCELLED"){
                    wfDisplay.onHoldOrRejectRequestIndex =  String(wfStatusIndex)
                    wfDisplay.cssClassValue = "wf stop"
                    wfDisplay.statusImage = UIImage.init(named: "reject")
                    wfDisplay.backGroundColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
                    
                }else if wf.status != nil && wf.wfId != nil && res.inProcessWf.wfId != nil &&  wf.status == "PENDING" && wf.wfId == res.inProcessWf.wfId{
                    
                    if wfDisplay.onHoldOrRejectRequestIndex == "" {
                        wfDisplay.inprocessFoundIndex = String(wfStatusIndex)
                        wfDisplay.cssClassValue = "wf inprocess"
                        wfDisplay.statusImage = UIImage.init(named: "pending_hourglass")
                        wfDisplay.backGroundColor = #colorLiteral(red: 0.9255, green: 0.5922, blue: 0.1216, alpha: 1) /* #ec971f */
                    }else{
                        wfDisplay.cssClassValue = "wf pending"
                        wfDisplay.backGroundColor = #colorLiteral(red: 0.502, green: 0.502, blue: 0.502, alpha: 1) /* #808080 */
                        wfDisplay.statusImage = UIImage.init(named: "awaiting")
                    }
                }else if wf.status != nil && wf.status == "PENDING"{
                    wfDisplay.cssClassValue = "wf pending"
                    wfDisplay.backGroundColor = #colorLiteral(red: 0.502, green: 0.502, blue: 0.502, alpha: 1) /* #808080 */
                    wfDisplay.statusImage = UIImage.init(named: "awaiting")
                }else if wf.status != nil && wf.status == "APPROVED"{
                    if wfDisplay.inprocessFoundIndex == "" &&  wfDisplay.onHoldOrRejectRequestIndex == "" {
                         wfDisplay.cssClassValue = "wf approved"
                         wfDisplay.statusImage = UIImage.init(named: "approved")
                         wfDisplay.backGroundColor = #colorLiteral(red: 0, green: 0.3922, blue: 0, alpha: 1) /* #006400 */
                    }else{
                         wfDisplay.cssClassValue = "wf pending"
                         wfDisplay.backGroundColor = #colorLiteral(red: 0.502, green: 0.502, blue: 0.502, alpha: 1) /* #808080 */
                         wfDisplay.statusImage = UIImage.init(named: "awaiting")
                    }
                }
                
                wfDisplay.lblAction = wf.action
                if wfDisplay.cssClassValue == "wf approved" || wfDisplay.cssClassValue == "wf stop"{
                    wfDisplay.lblDate = "Date: \(wf.approvedDate!)"
                }
                
                workFlowDisplayArray.append(wfDisplay)
                wfStatusIndex += 1
            }
            self.workFlowTable.reloadData()
        }
        
    }
    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workFlowDisplayArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewWorkFlowTableViewCell") as! ViewWorkFlowTableViewCell
        
        if workFlowDisplayArray.count > 0{
            
            cell.lblAction.text  = workFlowDisplayArray[indexPath.row].lblAction
            cell.lblDate.text = workFlowDisplayArray[indexPath.row].lblDate
            cell.statusImage.tintColor = UIColor.white
            cell.statusImage.image = workFlowDisplayArray[indexPath.row].statusImage
            cell.outerView.backgroundColor =  workFlowDisplayArray[indexPath.row].backGroundColor
            cell.selectionStyle = .none
            
            if indexPath.row == (workFlowDisplayArray.count - 1){
                cell.downArrowImage.alpha = 0
            }
        }
        return cell
        
    }
    
    
   
}
