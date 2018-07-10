//
//  SuccessViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 6/15/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController,UITabBarDelegate {

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    var originFrom: String?
    var message :String?
    var isStreetInterchangeInitiatedByMCA :String?
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var addNewTab: UITabBarItem!
    @IBOutlet weak var homeTab: UITabBar!
    @IBOutlet weak var successViewTabBar: UITabBar!
    
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblNoteDesc: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.successViewTabBar.delegate = self
        self.navigationItem.hidesBackButton = true
        self.addNewTab.title = "CREATE NEW REQUEST"
        
        /*
        if originFrom == "StreetTurn"{
            self.addNewTab.title = "ADD NEW STREET TURN REQUEST"
            
        }else if originFrom == "AddNotifAvailRequest"{
            self.addNewTab.title = "ADD NEW REQUEST TO POOL"
            
        }else{
            self.addNewTab.title = "ADD NEW STREET INTERCHANGE REQUEST"
        }*/
        
        lblMessage.text = message
        lblMessage.numberOfLines = 0
        lblMessage.sizeToFit()
        
        if originFrom == "StreetInterchange" && vu.isNotEmptyString(stringToCheck: isStreetInterchangeInitiatedByMCA!)
            && isStreetInterchangeInitiatedByMCA! == "N"{
            lblNote.alpha = 0
            lblNoteDesc.alpha = 0
        }else{
            lblNote.alpha = 1
            lblNoteDesc.alpha = 1
        }
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1 {
            //add new street turn request page
            
            if originFrom == "StreetTurn"{
                
                let vc = self.navigationController?.viewControllers[1] as! StreetTurnRequestViewController
                vc.originFrom = self.originFrom
                self.navigationController?.popToViewController(vc, animated: true)
            
            }else if originFrom == "AddNotifAvailRequest"{
               
                let vc = self.navigationController?.viewControllers[1] as! AddNotifAvailRequestVC
                vc.originFrom = "AddNewNotifAvailRequest"
                self.navigationController?.popToViewController(vc, animated: true)
                
            }else{
                
                let vc = self.navigationController?.viewControllers[1] as! StreetInterchangeViewController
                vc.originFrom = "AddNewStreetInterchange"
                self.navigationController?.popToViewController(vc, animated: true)
            }
            
            
            
        }else if item.tag == 2 {
            //go to dashboard
           self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
