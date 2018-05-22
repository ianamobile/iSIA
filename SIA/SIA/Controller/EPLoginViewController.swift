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
        
        //dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtScac,txtPassword])
        
        //set up the UI
        loginSecView.roundCorners([.topRight, .bottomRight], radius: 20)
        
        let loginGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MCLoginViewController.loginSecViewTapDetected))
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
            vc.role = "MC"
        }
        
        
    }
    func validateLoginFields() -> String {
        
        var retMsg : String = ""
        /*
         if vu.isNotEmptyString(stringToCheck: txtScac.text!) && vu.isNotEmptyString(stringToCheck: txtPassword.text!)
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
         */
        return retMsg
        
    }
    
    @IBAction func SignOnButtonTapped(_ sender: Any) {
        /*
         // resign first responder if any.
         if txtUserName.isFirstResponder
         {
         txtUserName.resignFirstResponder();
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
         "userName" : au.trim(stringToTrim: txtUserName.text!),
         "password" : au.trim(stringToTrim: txtPassword.text!),
         "role": "MC"
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
         applicationUtils.hideActivityIndicator(uiView: self.view)
         au.showAlert(target: self, alertTitle: "MC LOGIN", message: "Opp! An error has occured, please try after some time.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
         
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
         
         UserDefaults.standard.set(userDetails.accessToken!, forKey: "accessToken")
         UserDefaults.standard.set(userDetails.firstName!, forKey: "firstName")
         UserDefaults.standard.set(userDetails.lastName!, forKey: "lastName")
         UserDefaults.standard.set(userDetails.role!, forKey: "role")
         UserDefaults.standard.set(userDetails.userId, forKey: "userId")
         UserDefaults.standard.set(userDetails.scac, forKey: "scac")
         UserDefaults.standard.set(userDetails.originFrom, forKey: self.ac.MC_LOGIN)
         
         DispatchQueue.main.sync {
         applicationUtils.hideActivityIndicator(uiView: self.view)
         self.performSegue(withIdentifier: "dashboardSegue", sender: self)
         
         }
         
         }else{
         
         //handle other response ..
         let apiResponseMessage: APIResponseMessage  = APIResponseMessage(loginData)
         
         DispatchQueue.main.sync {
         applicationUtils.hideActivityIndicator(uiView: self.view)
         au.showAlert(target: self, alertTitle: "MC LOGIN", message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
         
         }
         
         }
         
         }
         
         
         } catch let error as NSError {
         print("NSError ::",error)
         applicationUtils.hideActivityIndicator(uiView: self.view)
         au.showAlert(target: self, alertTitle: "MC LOGIN", message: "Opp! An error has occured, please try after some time.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
         
         
         }
         
         
         }
         task.resume()
         
         }
         
         
         }else{
         
         //display toast message to the user.
         au.showAlert(target: self, alertTitle: "MC LOGIN", message: resMsg,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
         
         
         }
         */
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
