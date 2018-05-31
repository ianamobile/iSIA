//
//  IDDLogin2ViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/16/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class IDDLogin2ViewController: UIViewController, UITextFieldDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var backViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtScac: DesignableUITextField!
    @IBOutlet weak var txtDriverLicNo: DesignableUITextField!
    @IBOutlet weak var txtDriverLicState: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate self to apply border focus changes
        txtScac.delegate = self
        txtDriverLicNo.delegate = self
        txtDriverLicState.delegate = self
        
        self.backViewLeadingConstraint.constant = -self.backView.frame.width
        
        //dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtScac, txtDriverLicNo, txtDriverLicState])
        
        //set up the UI
        backView.roundCorners([.topRight, .bottomRight], radius: 20)
        
        let backViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backViewTapDetected))
        backView.addGestureRecognizer(backViewGestureRecognizer)
       
        
    }
    @objc func backViewTapDetected() {
        dismiss(animated: true, completion: nil)
    }
    
    func validateLoginFields() -> String {
        
        var retMsg : String = ""
        
        if vu.isNotEmptyString(stringToCheck: txtDriverLicNo.text!)
            && vu.isNotEmptyString(stringToCheck: txtDriverLicState.text!)
            && vu.isNotEmptyString(stringToCheck: txtScac.text!)
        {
            //in case of none of the field is empty
            if !txtDriverLicNo.text!.isAlphanumeric
            {
                retMsg = "Driver license # should contains alpanumeric only."
                
            }else if !txtDriverLicState.text!.isCharactersOnly
            {
                retMsg = "Driver license state should contains characters only."
                
            }else if txtDriverLicState.text!.count < 2
            {
                retMsg = "Driver license state should be 2 characters long."
                
            } else if !txtScac.text!.isCharactersOnly
            {
                retMsg = "SCAC should contains characters only."
                
            }else if txtScac.text!.count < 4
            {
                retMsg = "SCAC should be 4 characters long."
            }
            
        }else if vu.isNotEmptyString(stringToCheck: txtDriverLicNo.text!) && vu.isNotEmptyString(stringToCheck: txtDriverLicState.text!)
            && !vu.isNotEmptyString(stringToCheck: txtScac.text!){
            retMsg = "Please enter scac code."
            
        }else if vu.isNotEmptyString(stringToCheck: txtDriverLicNo.text!)
            && !vu.isNotEmptyString(stringToCheck: txtDriverLicState.text!)
            && vu.isNotEmptyString(stringToCheck: txtScac.text!){
            retMsg = "Please enter driver license state."
            
        }else if !vu.isNotEmptyString(stringToCheck: txtDriverLicNo.text!)
            && vu.isNotEmptyString(stringToCheck: txtDriverLicState.text!)
            && vu.isNotEmptyString(stringToCheck: txtScac.text!){
            retMsg = "Please enter driver license #."
            
        }else{
            // either or empty
            retMsg = "All fields are mandatory."
        }
        
        return retMsg
    }
    
    @IBAction func SignOnButtonTapped(_ sender: Any) {
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
                    
                    "role": "IDD",
                    "iddPin": "",
                    "driverLicenseNumber": au.trim(stringToTrim: txtDriverLicNo.text!),
                    "driverLicenseState": au.trim(stringToTrim: txtDriverLicState.text!),
                    "originFrom": ac.DRVLIC_STATE_SCAC,
                    "scac": au.trim(stringToTrim: txtScac.text!)
                    
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
                            au.showAlert(target: self, alertTitle: "IDD LOGIN", message: "Opp! An error has occured, please try after some time.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
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
                                    
                                    UserDefaults.standard.set(self.ac.DRVLIC_STATE_SCAC, forKey: "originFrom")
                                    UserDefaults.standard.set(self.txtDriverLicNo.text!, forKey:"driverLicenseNumber")
                                    UserDefaults.standard.set(self.txtDriverLicState.text!, forKey:"driverLicenseState")
                                    
                                    
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    self.performSegue(withIdentifier: "dashboardSegue", sender: self)
                                    
                                }
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(loginData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: "IDD LOGIN", message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: "IDD LOGIN", message: "Opp! An error has occured, please try after some time.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                    }
                    
                    
                }
                task.resume()
                
            }
            
            
        }else{
            
            //display toast message to the user.
            au.showAlert(target: self, alertTitle: "IDD LOGIN", message: resMsg,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.backViewLeadingConstraint.constant += self.backView.frame.width
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.backViewLeadingConstraint.constant = -self.backView.frame.width
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
            
        }else if textField == txtDriverLicNo
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 20
            
        }else if textField == txtDriverLicState
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 2
            
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
