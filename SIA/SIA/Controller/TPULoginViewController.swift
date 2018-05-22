//
//  TPULoginViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/14/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class TPULoginViewController: UIViewController, UITextFieldDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    
    @IBOutlet weak var txtUserName: DesignableUITextField!
    @IBOutlet weak var txtPassword: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate self to apply border focus changes
        txtUserName.delegate = self
        txtPassword.delegate = self
        
        
        //dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtUserName,txtPassword])
        
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
            }
            
        }
        
    }
    
    func validateLoginFields() -> String {
        
        var retMsg : String = ""
        
        if vu.isNotEmptyString(stringToCheck: txtUserName.text!) && vu.isNotEmptyString(stringToCheck: txtPassword.text!)
        {
            //both are not empty case
            if !txtUserName.text!.isAlphanumeric
            {
                retMsg = "Username should contains alpanumeric only."
            }
            
        }else if vu.isNotEmptyString(stringToCheck: txtUserName.text!) && !vu.isNotEmptyString(stringToCheck: txtPassword.text!){
            retMsg = "Please enter password."
            
        }else if !vu.isNotEmptyString(stringToCheck: txtUserName.text!) && vu.isNotEmptyString(stringToCheck: txtPassword.text!){
            retMsg = "Please enter username."
            
        }else
        {
            // either or empty
            retMsg = "Please enter username & password."
            
            
        }
        return retMsg
    }
    
    @IBAction func SignOnButtonTapped(_ sender: UIButton) {
         
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField == txtUserName
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 50
            
        }else if textField == txtPassword
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 100
            
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
