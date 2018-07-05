//
//  LoginUITabBarController.swift
//  DVIR
//
//  Created by Piyush Panchal on 1/23/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class LoginUITabBarController: UITabBarController {

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    
    var tabBarItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //method that check user has internet connected in mobile or not.
    override func viewDidAppear(_ animated: Bool)
    {
        if !au.isInternetAvailable()
        {
            au.redirectToNoInternetConnectionView(target: self)
        }else
        {
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            print("access Token \(String(describing: accessToken))")
            if(accessToken != nil && vu.isNotEmptyString(stringToCheck: accessToken!)){
                self.performSegue(withIdentifier: "dashboardSegue", sender: self)
            }else{
                super.viewDidAppear(animated)
                
            }
            
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //do our animations
        self.tabBarItemImageView = self.tabBar.subviews[item.tag].subviews.first as! UIImageView
        self.tabBarItemImageView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            let transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            
           // let rotation = CGAffineTransform.init(translationX: oldX, y: oldY - 5)
            self.tabBarItemImageView.transform = transform
            
        }, completion: { (value: Bool) in
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                 self.tabBarItemImageView.transform = .identity
            }, completion: nil)
           
        })
            
        
 
        
        
    }
    
}
