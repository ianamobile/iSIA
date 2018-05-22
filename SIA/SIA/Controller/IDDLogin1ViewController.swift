//
//  IDDLogin1ViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/16/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class IDDLogin1ViewController: UIViewController, UITextFieldDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    
    @IBOutlet weak var loginViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var txtScac: DesignableUITextField!
    @IBOutlet weak var txtIddPin: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate self to apply border focus changes
        txtScac.delegate = self
        txtIddPin.delegate = self
        
        self.loginViewLeadingConstraint.constant = -self.loginView.frame.width
        
        //dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtScac,txtIddPin])
        
        //set up the UI
        loginView.roundCorners([.topRight, .bottomRight], radius: 20)
        
        let loginGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MCLoginViewController.loginSecViewTapDetected))
        loginView.addGestureRecognizer(loginGestureRecognizer)
        
    }
    
    @objc func loginSecViewTapDetected() {
        print("loginSecViewTapDetected...")
        self.performSegue(withIdentifier: "iddLogin2Segue", sender: self)
        
    }
    
    @IBAction func SignOnButtonTapped(_ sender: Any) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.loginViewLeadingConstraint.constant += self.loginView.frame.width
                UIView.animate(withDuration: 1) {
                    self.view.layoutIfNeeded()
                    
                }
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.loginViewLeadingConstraint.constant = -self.loginView.frame.width
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField == txtScac
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 4
            
        }else if textField == txtIddPin
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 15
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            textField.resignFirstResponder();
            self.SignOnButtonTapped(UIButton());
            return false;
        }
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        au.focusTextField(uiView: self.view, textField: textField)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        au.blurTextField(uiView: self.view, textField: textField)
        
    }
    
    
}

