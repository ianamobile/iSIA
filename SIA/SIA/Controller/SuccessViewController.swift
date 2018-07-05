//
//  SuccessViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 6/15/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController,UITabBarDelegate {

    @IBOutlet weak var lblMessage: UILabel!
    var originFrom: String?
    var message :String?
    
    @IBOutlet weak var addNewTab: UITabBarItem!
    @IBOutlet weak var homeTab: UITabBar!
    @IBOutlet weak var successViewTabBar: UITabBar!
    
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
                vc.originFrom = self.originFrom
                self.navigationController?.popToViewController(vc, animated: true)
            }
            
            
            
        }else if item.tag == 2 {
            //go to dashboard
           self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
