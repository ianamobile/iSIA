//
//  OperationSuccessViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 7/20/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class OperationSuccessViewController: UIViewController ,UITabBarDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    var originFrom: String?
    var message :String?
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var addNewTab: UITabBarItem!
    @IBOutlet weak var homeTab: UITabBar!
    @IBOutlet weak var successViewTabBar: UITabBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.successViewTabBar.delegate = self
        self.navigationItem.hidesBackButton = true
       
        
        lblMessage.text = message
        lblMessage.numberOfLines = 0
        lblMessage.sizeToFit()
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1 {
            //approve another request
            
            
            if self.navigationController != nil && self.navigationController?.viewControllers != nil {
                for viewController  in (self.navigationController?.viewControllers)!{
                    if viewController.isKind(of: SearchInterchangeRequestResultVC.self){
                        let vc = viewController as! SearchInterchangeRequestResultVC
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
            
        }else if item.tag == 2 {
            //go to dashboard
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
