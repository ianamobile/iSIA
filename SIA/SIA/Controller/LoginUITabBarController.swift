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
}
