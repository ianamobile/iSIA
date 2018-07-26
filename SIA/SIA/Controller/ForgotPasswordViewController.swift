//
//  ForgotPasswordViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/10/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()

    @IBOutlet weak var backViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtScac: DesignableUITextField!
    
    //variables mapped with mc-ep login screen.
    var role : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //delegate self to apply border focus changes
        txtScac.delegate = self
        
        self.backViewLeadingConstraint.constant = -self.backView.frame.width
        
        if role == "MC" {
            txtScac.placeholder = "ENTER MC SCAC"
        }else{
            txtScac.placeholder = "ENTER EP SCAC"
        }
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtScac])
        
        //set up the UI
        backView.roundCorners([.topRight, .bottomRight], radius: 20)
        
        let backViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backViewTapDetected))
        backView.addGestureRecognizer(backViewGestureRecognizer)
        
        print("role is \(String(describing: role)) ")
        
    }
    @objc func backViewTapDetected() {
        dismiss(animated: true, completion: nil)
    }
    
    func validateForgotPasswordFields() -> String {
        
        var retMsg : String = ""
        
        if vu.isNotEmptyString(stringToCheck: txtScac.text!)
        {
            //both are not empty case
            if !txtScac.text!.isCharactersOnly
            {
                retMsg = "SCAC should contains characters only."
                
            }else if role == "MC" && txtScac.text!.count < 4
            {
                retMsg = "SCAC should be 4 characters long."
            
            }else if role == "EP" && txtScac.text!.count < 2
            {
                retMsg = "SCAC should be 2- 4 characters long."
            }
            
        }else
        {
            retMsg = "Scac should not be blank."
        }
        return retMsg
    }
    @IBAction func SubmitOnButtonTapped(_ sender: Any) {
        if txtScac.isFirstResponder
        {
            txtScac.resignFirstResponder();
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
                    "scac" : au.trim(stringToTrim: txtScac.text!),
                    "role" : role!,
                    
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
                                    
                                    self.txtScac.text = ""
                                 
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
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            textField.resignFirstResponder();
            self.SubmitOnButtonTapped(UIButton());
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
