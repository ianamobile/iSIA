//
//  DashboardTableViewController.swift
//  AnimatedMenu
//
//  Created by Piyush Panchal on 5/25/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController, DashboardTableViewCellDelegate{
    
    @IBOutlet var dashboardTableView: UITableView!
   
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    //MC Section Start
    let mcMenuArr:[Int] = [4, 2, 7, 3, 0, 1, 20]
    let mcSecDefaultRightsMenuArr:[Int] = [0, 20]
    let mcSecSingleRightsMenuArr:[Int] = [4, 2, 0, 1, 20]
    let mcSecFullRightsMenuArr:[Int] = [4, 2, 7, 3, 0, 1, 20]
    
   
    //EP Section Start
    let epMenuArr:[Int] = [2, 7, 3, 0, 1, 20]
    let epSecDefaultRightsMenuArr:[Int] = [20]
    let epSecSingleRightsMenuArr:[Int] = [2, 0, 1, 20]
    let epSecFullRightsMenuArr:[Int] = [2, 7, 3, 0, 1, 20]
    
    //IDD Section
    let iddMenuArr:[Int] = [4, 2, 7, 3, 0, 1, 20]
    
    //TPU Section
    let tpuDefaultRightsMenuArr:[Int] = [5, 6, 20]
    let tpuSingleRightsMenuArr:[Int] = [2, 0, 1, 5, 6, 20]
    let tpuFullRightsMenuArr:[Int] = [2, 7, 3, 0, 1, 5, 6, 20]
    
    //final array which hold run time value from the rights based login.
    var finalArr:[Int] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashboardTableView.dataSource = self
        dashboardTableView.delegate = self
        dashboardTableView.separatorColor = UIColor.clear
        
        let role =  UserDefaults.standard.string(forKey: "role")
        
        if(role == "MC")
        {
            finalArr = mcMenuArr
            
        }else if(role == "EP")
        {
            finalArr = epMenuArr
            
        }else if(role == "IDD")
        {
            finalArr = iddMenuArr
            
        }else if(role == "TPU"){
            finalArr = tpuDefaultRightsMenuArr
            
        }else if(role == "SEC"){
            
            let memType =  UserDefaults.standard.string(forKey: "memType")
            let iniIntrchng =  UserDefaults.standard.string(forKey: "iniIntrchng")
            let iniIntrchngAndApprove =  UserDefaults.standard.string(forKey: "iniIntrchngAndApprove")
            
            if(memType == "MC"){
            
                if (iniIntrchngAndApprove != nil && iniIntrchngAndApprove != "" && iniIntrchngAndApprove == "Y"){
                    finalArr = mcSecFullRightsMenuArr
                }else if (iniIntrchng != nil && iniIntrchng != "" && iniIntrchng == "Y"){
                    finalArr = mcSecSingleRightsMenuArr
                }else{
                    finalArr = mcSecDefaultRightsMenuArr
                }
            
            }else if(memType == "EP"){
                
                if (iniIntrchngAndApprove != nil && iniIntrchngAndApprove != "" && iniIntrchngAndApprove == "Y"){
                    finalArr = epSecFullRightsMenuArr
                }else if (iniIntrchng != nil && iniIntrchng != "" && iniIntrchng == "Y"){
                    finalArr = epSecSingleRightsMenuArr
                }else{
                    finalArr = epSecDefaultRightsMenuArr
                }
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pendingInterchangeReqSegue"
        {
            let vc = segue.destination as! SearchInterchangeRequestResultVC
            vc.actionRequired =  "Y"
            
            
        }
    }
  func findAndNavigateToTappedView(sender: DashboardTableViewCell, originFrom: String) {
       if(originFrom == "left"){
        if sender.leftView.tag == ac.LOGOUT_INDEX {
            self.logoutViewTapDetected()
        }else{
            self.performSegue(withIdentifier: ac.menuSegueArr[sender.leftView.tag], sender: self)
        }
        
        }else{
        
            if sender.rightView.tag == ac.LOGOUT_INDEX {
                self.logoutViewTapDetected()
            }else{
                 self.performSegue(withIdentifier: ac.menuSegueArr[sender.rightView.tag], sender: self)
            }
        
        }
  }
    
    @objc func logoutViewTapDetected() {
       
        UserDefaults.standard.removeObject(forKey:  "accessToken")
        UserDefaults.standard.removeObject(forKey: "companyName")
        UserDefaults.standard.removeObject(forKey: "memType")
        UserDefaults.standard.removeObject(forKey: "role")
        UserDefaults.standard.removeObject(forKey: "scac")
        
        if UserDefaults.standard.string(forKey: "originFrom") == ac.IDDPIN_SCAC
        {
            UserDefaults.standard.removeObject(forKey: "iddPin")
            
        }else if UserDefaults.standard.string(forKey: "originFrom") == ac.DRVLIC_STATE_SCAC
        {
            UserDefaults.standard.removeObject(forKey: "driverLicenseNumber")
            UserDefaults.standard.removeObject(forKey: "driverLicenseState")
            
        }
        UserDefaults.standard.removeObject(forKey: "originFrom")
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginUITabBarController = storyboard.instantiateViewController(withIdentifier: "LoginUITabBarController") as! LoginUITabBarController
        self.present(loginUITabBarController, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(ceil(Double(finalArr.count) / 2))
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardTableViewCell", for: indexPath) as! DashboardTableViewCell
        
        //this is used to mapped the delegate between the tableview cell and this controller. when user tapped to any menu it should be navigate to new view based on this below line.
        cell.delegate = self
        cell.selectionStyle = .none //table cell row lines removed.
        
        let leftIndex  = indexPath.row * 2
        let rightIndex = (indexPath.row * 2) + 1
        
        
        cell.leftView.tag  = finalArr[leftIndex]
        if(rightIndex <  finalArr.count){
            cell.rightView.tag = finalArr[rightIndex]
        }
        
        if(leftIndex <= finalArr.count){
            
            cell.leftLabel.text = ac.menuTitleArr[finalArr[leftIndex]]
            cell.leftCircleViewImage.image = UIImage.init(named: ac.menuIconArr[finalArr[leftIndex]])
            
            if(rightIndex >=  finalArr.count){
                 cell.hideRightMenu()
            }else{
                cell.rightLabel.text = ac.menuTitleArr[finalArr[rightIndex]]
                cell.rightCircleViewImage.image = UIImage.init(named: ac.menuIconArr[finalArr[rightIndex]])
            }
        }
        
        return cell
    }
   
}
