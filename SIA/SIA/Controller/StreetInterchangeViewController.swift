//
//  StreetInterchangeViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 6/5/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class StreetInterchangeViewController: UIViewController , UITextFieldDelegate, LocationSearchTableViewCellDelegate{
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var txtEPCompanyName: DesignableUITextField!
    @IBOutlet weak var txtEPScac: DesignableUITextField!
    @IBOutlet weak var txtMCACompanyName: DesignableUITextField!
    @IBOutlet weak var txtMCAScac: DesignableUITextField!
    @IBOutlet weak var txtMCBCompanyName: DesignableUITextField!
    @IBOutlet weak var txtMCBScac: DesignableUITextField!
    
    @IBOutlet weak var txtTypeOfInterchange: DesignableUITextField!
    @IBOutlet weak var txtContType: DesignableUITextField!
    @IBOutlet weak var txtContSize: DesignableUITextField!
    @IBOutlet weak var txtImportBookingNum: DesignableUITextField!
    @IBOutlet weak var txtExportBookingNum: DesignableUITextField!
    @IBOutlet weak var txtContNum: DesignableUITextField!
    @IBOutlet weak var txtChassisNum: DesignableUITextField!
    @IBOutlet weak var txtChassisIEPScac: DesignableUITextField!
    
    @IBOutlet weak var txtChassisType: DesignableUITextField!
    @IBOutlet weak var txtChassisSize: DesignableUITextField!
    @IBOutlet weak var txtGensetNum: DesignableUITextField!
 
   
    

    
    @IBOutlet weak var txtEquipZipCode: DesignableUITextField!
    @IBOutlet weak var txtEquipLocationName: DesignableUITextField!
    @IBOutlet weak var txtEquipLocationAddress: DesignableUITextField!
    @IBOutlet weak var txtEquipCity: DesignableUITextField!
    @IBOutlet weak var txtEquipState: DesignableUITextField!
    
    @IBOutlet weak var txtOriginZipCode: DesignableUITextField!
    @IBOutlet weak var txtOriginLocationName: DesignableUITextField!
    @IBOutlet weak var txtOriginLocationAddress: DesignableUITextField!
    @IBOutlet weak var txtOriginCity: DesignableUITextField!
    @IBOutlet weak var txtOriginState: DesignableUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate self to apply border focus changes
        
        txtEPCompanyName.delegate = self
        txtEPScac.delegate = self
        txtMCACompanyName.delegate = self
        txtMCAScac.delegate = self
        txtMCBCompanyName.delegate = self
        txtMCBScac.delegate = self
        
        txtTypeOfInterchange.delegate = self
        txtContType.delegate = self
        txtContSize.delegate = self
        txtImportBookingNum.delegate = self
        txtExportBookingNum.delegate = self
        txtContNum.delegate = self
        txtChassisNum.delegate = self
        txtChassisIEPScac.delegate = self
        
        txtChassisType.delegate = self
        txtChassisSize.delegate = self
        txtGensetNum.delegate = self
        
        txtEquipZipCode.delegate = self
        txtEquipLocationName.delegate = self
        txtEquipLocationAddress.delegate = self
        txtEquipCity.delegate = self
        txtEquipState.delegate = self
        
        txtOriginZipCode.delegate = self
        txtOriginLocationName.delegate = self
        txtOriginLocationAddress.delegate = self
        txtOriginCity.delegate = self
        txtOriginState.delegate = self
        
        //dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Go to next field on return key
        /*UITextField.connectFields(fields: [txtMCACompanyName, txtEPCompanyName, txtContNum, txtExportBookingNum, txtImportBookingNum, txtChassisNum])
        */
        
    }
    
    func findAndNavigateToTappedView(selectedLocation: IANALocationInfo, originFrom: String) {
        print("request came here..")
        if originFrom  == ac.ORIGINAL_LOCATION
        {
            txtOriginZipCode.text = selectedLocation.zip
            txtOriginLocationName.text = selectedLocation.facilityName
            txtOriginLocationAddress.text = selectedLocation.address
            txtOriginCity.text = selectedLocation.city
            txtOriginState.text = selectedLocation.state
        }else if originFrom == ac.EQUIPMENT_LOCATION
        {
            txtEquipZipCode.text = selectedLocation.zip
            txtEquipLocationName.text = selectedLocation.facilityName
            txtEquipLocationAddress.text = selectedLocation.address
            txtEquipCity.text = selectedLocation.city
            txtEquipState.text = selectedLocation.state
        }
        
    }
    
    @IBAction func searchEquipLocationButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "searchEquipmentLocSegue", sender: self)
    }
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "searchOriginalLocSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchOriginalLocSegue"
        {
            let vc = segue.destination as! LocationSearchTableViewController
            vc.delegate = self
            vc.epScac = "MSCU"
            vc.originFrom = ac.ORIGINAL_LOCATION
       
        }else if segue.identifier == "searchEquipmentLocSegue"
        {
            let vc = segue.destination as! LocationSearchTableViewController
            vc.delegate = self
            vc.originFrom = ac.EQUIPMENT_LOCATION
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
        if textField == txtOriginZipCode || textField == txtOriginCity  || textField == txtOriginState
            || textField == txtOriginLocationAddress || textField == txtOriginLocationName
            || textField == txtChassisIEPScac || textField == txtMCAScac
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
