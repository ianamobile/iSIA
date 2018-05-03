//
//  NoInternetViewController.swift
//  BOES
//
//  Created by Piyush Panchal on 8/11/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func retryButtonTapped(_ sender: UIButton)
    {
      
        if ApplicationUtils.isInternetAvailable()
        {
            /*
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginUITabBarController = storyboard.instantiateViewController(withIdentifier: "LoginUITabBarController") as! LoginUITabBarController
            self.present(loginUITabBarController, animated: true, completion: nil)
       */
        }
        
    }

}
