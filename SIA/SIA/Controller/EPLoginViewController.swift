//
//  EPLoginViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/9/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class EPLoginViewController: UIViewController, UITextFieldDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var loginSecViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginSecView: UIView!
    @IBOutlet weak var txtScac: DesignableUITextField!
    @IBOutlet weak var txtPassword: DesignableUITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate self to apply border focus changes
        txtScac.delegate = self
        txtPassword.delegate = self
        
        self.loginSecViewLeadingConstraint.constant = -self.loginSecView.frame.width
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtScac,txtPassword])
        
        //set up the UI
        loginSecView.roundCorners([.topRight, .bottomRight], radius: 20)
        
        let loginGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.loginSecViewTapDetected))
        loginSecView.addGestureRecognizer(loginGestureRecognizer)
       
    }
    
    @objc func loginSecViewTapDetected() {
        print("loginSecViewTapDetected...")
        self.performSegue(withIdentifier: "loginEPSecSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginEPSecSegue"
        {
            let vc = segue.destination as! SECUserLoginViewController
            vc.memType = "EP"
            
        }else if segue.identifier == "forgotPasswordEPSegue"
        {
            let vc = segue.destination as! ForgotPasswordViewController
            vc.role = "EP"
        }
        
        
    }
    func validateLoginFields() -> String {
        
        var retMsg : String = ""
        
        if vu.isNotEmptyString(stringToCheck: txtScac.text!) && vu.isNotEmptyString(stringToCheck: txtPassword.text!)
        {
            //both are not empty case
            if !txtScac.text!.isCharactersOnly
            {
                retMsg = "SCAC should contains characters only."
                
            }else if txtScac.text!.count < 2 {
                
                retMsg = "SCAC should be 2-4 characters long."
            }
            
        }else if vu.isNotEmptyString(stringToCheck: txtScac.text!) && !vu.isNotEmptyString(stringToCheck: txtPassword.text!){
            retMsg = "Password should not be blank."
            
        }else if !vu.isNotEmptyString(stringToCheck: txtScac.text!) && vu.isNotEmptyString(stringToCheck: txtPassword.text!){
            retMsg = "Scac should not be blank."
            
        }else
        {
            // either or empty
            retMsg = "Scac & Password should not be blank."
            
            
        }
        return retMsg
        
    }
    
    @IBAction func SignOnButtonTapped(_ sender: Any) {
        // resign first responder if any.
        if txtScac.isFirstResponder
        {
            txtScac.resignFirstResponder();
        }else if txtPassword.isFirstResponder
        {
            txtPassword.resignFirstResponder();
        }
        // validate Login fields..
        let resMsg : String = validateLoginFields()
        
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else if resMsg.isEmpty
        {
            
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let jsonRequestObject: [String : Any] =
                [
                    "scac" : au.trim(stringToTrim: txtScac.text!),
                    "password" : au.trim(stringToTrim: txtPassword.text!),
                    "role": "EP"
            ]
            
            //print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.LOGIN_URI
                let url = URL(string: urlToRequest)!
                
                let session = URLSession.shared
                let request = NSMutableURLRequest(url: url)
                
                request.httpMethod = "POST"
                request.httpBody = paramString
                request.setValue(ac.CONTENT_TYPE_JSON, forHTTPHeaderField: ac.CONTENT_TYPE_KEY)
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                    guard let _: Data = data, let _: URLResponse = response, error == nil else {
                        print("*****error")
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: "EP LOGIN", message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                        
                        return
                    }
                    do{
                        let nsResponse =  response as! HTTPURLResponse
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        
                        print(parsedData)
                        
                        if let loginData:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                let userDetails: UserDetails  = UserDetails(loginData)
                                //print(userDetails.accessToken!)
                                
                                DispatchQueue.main.sync {
                                    UserDefaults.standard.set(userDetails.accessToken!, forKey: "accessToken")
                                    UserDefaults.standard.set(userDetails.companyName!, forKey: "companyName")
                                    UserDefaults.standard.set(userDetails.role!, forKey: "role")
                                    UserDefaults.standard.set(userDetails.scac, forKey: "scac")
                                    UserDefaults.standard.set(userDetails.role!, forKey: "originFrom")
                                    
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    self.performSegue(withIdentifier: "dashboardSegue", sender: self)
                                    
                                }
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(loginData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: "EP LOGIN", message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: "EP LOGIN", message: self.ac.ERROR_MSG ,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                task.resume()
                
            }
            
            
        }else{
            
            //display toast message to the user.
            au.showAlert(target: self, alertTitle: "EP LOGIN", message: resMsg,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                self.loginSecViewLeadingConstraint.constant += self.loginSecView.frame.width
                UIView.animate(withDuration: 1) {
                    self.view.layoutIfNeeded()
                    
                }
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.loginSecViewLeadingConstraint.constant = -self.loginSecView.frame.width
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
