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
        
        //dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
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
    
    @IBAction func SubmitOnButtonTapped(_ sender: Any) {
        
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
