//
//  TPUForgotPasswordViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/10/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class TPUForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var backViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtUserName: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate self to apply border focus changes
        txtUserName.delegate = self
        
        self.backViewLeadingConstraint.constant = -self.backView.frame.width
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtUserName])
        
        //set up the UI
        backView.roundCorners([.topRight, .bottomRight], radius: 20)
        
        let backViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backViewTapDetected))
        backView.addGestureRecognizer(backViewGestureRecognizer)
        
        
    }
    func validateForgotPasswordFields() -> String {
        
        var retMsg : String = ""
        
        if vu.isNotEmptyString(stringToCheck: txtUserName.text!)
        {
            //both are not empty case
            if !txtUserName.text!.isAlphanumeric
            {
                retMsg = "Username should contains alphanumeric only."
            }
            
        }else
        {
            retMsg = "Username should not be blank."
        }
        return retMsg
    }
 
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        if txtUserName.isFirstResponder
        {
            txtUserName.resignFirstResponder();
        }
        
        let resMsg : String = validateForgotPasswordFields()
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
                    "role" : "TPU",
                    
                    ]
            
            //print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.FORGOT_PASSWORD_URI
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
                            au.showAlert(target: self, alertTitle: "FORGOT PASSWORD", message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        return
                    }
                    do{
                        let nsResponse =  response as! HTTPURLResponse
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        
                        
                        if let forgotPasswordData:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                let apiResponseMessageSuccess: APIResponseMessage  = APIResponseMessage(forgotPasswordData)
                                
                                DispatchQueue.main.sync {
                                    
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: "FORGOT PASSWORD", message: apiResponseMessageSuccess.message!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                    
                                     self.txtUserName.text = ""
                                }
                                
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(forgotPasswordData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: "FORGOT PASSWORD", message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: "FORGOT PASSWORD", message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                    }
                    
                    
                }
                task.resume()
                
            }
            
            
            
            
        }else{
            
            //display toast message to the user.
            au.showAlert(target: self, alertTitle: "FORGOT PASSWORD", message: resMsg,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            
        }
    }
    @objc func backViewTapDetected() {
        dismiss(animated: true, completion: nil)
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
        
        if textField == txtUserName
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 50
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            textField.resignFirstResponder();
            self.SubmitButtonTapped(UIButton());
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
