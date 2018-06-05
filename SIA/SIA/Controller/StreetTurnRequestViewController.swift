//
//  StreetTurnRequestViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/31/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class StreetTurnRequestViewController: UIViewController,  UITextFieldDelegate, LocationSearchTableViewCellDelegate{
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    

    @IBOutlet weak var txtMCCompanyName: DesignableUITextField!
    @IBOutlet weak var txtMCScac: DesignableUITextField!
    @IBOutlet weak var txtEPCompanyName: DesignableUITextField!
    @IBOutlet weak var txtEPScac: DesignableUITextField!
    @IBOutlet weak var txtContNum: DesignableUITextField!
    
    @IBOutlet weak var txtExportBookingNum: DesignableUITextField!
    @IBOutlet weak var txtImportBookingNum: DesignableUITextField!
    @IBOutlet weak var txtChassisNum: DesignableUITextField!
    @IBOutlet weak var txtChassisIEPScac: DesignableUITextField!
    
    @IBOutlet weak var txtZipCode: DesignableUITextField!
    @IBOutlet weak var txtLocationName: DesignableUITextField!
    @IBOutlet weak var txtLocationAddress: DesignableUITextField!
    @IBOutlet weak var txtCity: DesignableUITextField!
    @IBOutlet weak var txtState: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate self to apply border focus changes
        txtMCCompanyName.delegate = self
        txtMCScac.delegate = self
        txtEPCompanyName.delegate = self
        txtEPScac.delegate = self
        txtContNum.delegate = self
        
        txtExportBookingNum.delegate = self
        txtImportBookingNum.delegate = self
        txtChassisNum.delegate = self
        txtChassisIEPScac.delegate = self
        
        
        txtZipCode.delegate = self
        txtLocationName.delegate = self
        txtLocationAddress.delegate = self
        txtCity.delegate = self
        txtState.delegate = self
        
        //dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        //Go to next field on return key
        UITextField.connectFields(fields: [txtMCCompanyName, txtEPCompanyName, txtContNum, txtExportBookingNum, txtImportBookingNum, txtChassisNum])
        
    }
    
    func findAndNavigateToTappedView(selectedLocation: IANALocationInfo, originFrom: String) {
        print("request came here..")
        txtZipCode.text = selectedLocation.zip
        txtLocationName.text = selectedLocation.facilityName
        txtLocationAddress.text = selectedLocation.address
        txtCity.text = selectedLocation.city
        txtState.text = selectedLocation.state
        
    }
   
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "searchOriginalLocSegue", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "searchOriginalLocSegue"
        {
            let vc = segue.destination as! OriginalLocationSearchTableViewController
            vc.delegate = self
            vc.epScac = "MSCU"
            
        }
      
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtZipCode || textField == txtCity  || textField == txtState
                        || textField == txtLocationAddress || textField == txtLocationName
                            || textField == txtChassisIEPScac || textField == txtMCScac
                                || textField == txtEPScac
            
        {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*guard let text = textField.text else { return true }
        
        if textField == txtScac
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 4
            
        }else if textField == txtPassword
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 100
            
        }*/
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            textField.resignFirstResponder();
            self.nextButtonTapped(UIButton());
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
