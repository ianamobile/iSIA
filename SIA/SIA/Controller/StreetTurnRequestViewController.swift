//
//  StreetTurnRequestViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/31/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class StreetTurnRequestViewController: UIViewController,  UITextFieldDelegate, UITabBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, LocationSearchTableViewCellDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var streetTurnTabBar: UITabBar!
    
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
    
    var companyInfoArray  = [CompanyInfo]()
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streetTurnTabBar.delegate = self
        
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
        
        txtMCCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtEPCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtMCCompanyName, txtEPCompanyName, txtContNum, txtExportBookingNum, txtImportBookingNum, txtChassisNum])
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == txtMCCompanyName
        {
            loadListCompanyNameAndSCACByInput(textField)
        }
        
    }
    
    func loadListCompanyNameAndSCACByInput(_ textField: UITextField){
        var role :String = ""
        if textField == txtMCCompanyName{
             self.txtMCScac.text = ""
             role = "MC"
        }else if textField == txtEPCompanyName{
             self.txtEPScac.text = ""
             role = "EP"
        }
        
        let txtValue: String = au.replaceWhiteSpaces(au.trimSpaceAndNewLine(stringToTrimIncludingNewLine: (textField.text!)))
        if vu.isNotEmptyString(stringToCheck: txtValue)  && txtValue.count >= 3
        {
            //make a web service call to fetch boes location based on user.
            if !au.isInternetAvailable() {
                au.redirectToNoInternetConnectionView(target: self)
            }
            else
            {
                let applicationUtils : ApplicationUtils = ApplicationUtils()
                applicationUtils.showActivityIndicator(uiView: view)
                
                let urlToRequest = ac.BASE_URL + ac.GET_LIST_COMPANYNAME_SCAC + "?requestType=IR_REQUEST&role=\(role)&comapanyName=\(txtValue)"
                //print(urlToRequest)
                
                
                let url = URL(string: urlToRequest)!
                
                let session = URLSession.shared
                let request = NSMutableURLRequest(url: url)
                
                request.httpMethod = "GET"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                    guard let _: Data = data, let _: URLResponse = response, error == nil else {
                        print("*****error")
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: "STREET TURN", message: "Opp! An error has occured, please try after some time.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                        
                        return
                    }
                    do{
                        let nsResponse =  response as! HTTPURLResponse
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        
                        //print(parsedData)
                        
                        if nsResponse.statusCode == 200
                        {
                            
                            if let _data:NSArray   = parsedData as? NSArray
                            {
                                let companyDetails: Company  = Company(_data)
                                DispatchQueue.main.sync {
                                    self.companyInfoArray = [CompanyInfo]()
                                    for company in companyDetails.companyInfoArray
                                    {
                                        self.companyInfoArray.append(company)
                                        
                                    }
                                    
                                    self.picker.reloadAllComponents()
                                    // Changing the input type to picker instead of keyboard
                                    if(self.companyInfoArray.count > 0) {
                                        
                                        // below 3 lines are to set inputview as picker and to see picker immediately
                                        textField.inputView = self.picker
                                        textField.resignFirstResponder()
                                        textField.becomeFirstResponder()
                                    }
                                    else {
                                        
                                        // below 3 lines are to set inputview as default keyboard
                                        textField.inputView = nil;
                                        textField.resignFirstResponder()
                                        textField.becomeFirstResponder()
                                    }
                                    //print("self.companyInfoArray : \(self.companyInfoArray.count)")
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                }
                                
                            }
                            
                        }else if let _data:[String:Any]   = parsedData as? [String:Any]
                        {
                            
                            //handle other response ..
                            let apiResponseMessage: APIResponseMessage  = APIResponseMessage(_data)
                            
                            DispatchQueue.main.sync {
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                au.showAlert(target: self, alertTitle: "STREET TURN", message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: "STREET TURN", message: "Opp! An error has occured, please try after some time.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                    }
                    
                    
                }
                task.resume()
                
            }
            
        }else
        {
            self.companyInfoArray = [CompanyInfo]()
            self.picker.reloadAllComponents()
            // below 3 lines are to set inputview as default keyboard
            textField.inputView = nil;
            textField.resignFirstResponder()
            textField.becomeFirstResponder()
            
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if companyInfoArray.count > 0 {
            picker.isHidden = false
        }
        else {
            picker.isHidden = true
        }
        return companyInfoArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto", size: 10)
        label.numberOfLines = 0
        label.sizeToFit()
        
        // where data is an Array of String
        label.text = companyInfoArray[row].companyName! + "-" + companyInfoArray[row].scac!
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(locationArray[row])
        txtMCCompanyName.resignFirstResponder()
        
        txtMCCompanyName.text = self.companyInfoArray[row].companyName
        txtMCScac.text = self.companyInfoArray[row].scac
        
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
            
        }
      
    }
    func findAndNavigateToTappedView(selectedLocation: IANALocationInfo, originFrom: String) {
        
        txtZipCode.text = selectedLocation.zip
        txtLocationName.text = selectedLocation.facilityName
        txtLocationAddress.text = selectedLocation.address
        txtCity.text = selectedLocation.city
        txtState.text = selectedLocation.state
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        
        if item.tag == 1 {
            //next button tapped
            
            var fieldDataArr = [String]()
            var fieldTitleArr = [String]()
            
            fieldTitleArr.append("blank")
            fieldTitleArr.append("CONTAINER PROVIDER NAME")
            fieldTitleArr.append("CONTAINER PROVIDER SCAC")
            fieldTitleArr.append("MOTOR CARRIER'S NAME")
            fieldTitleArr.append("MOTOR CARRIER'S SCAC")
            fieldTitleArr.append("IMPORT B/L")
            fieldTitleArr.append("EXPORT BOOKING#")
            fieldTitleArr.append("CONTAINER #")
            fieldTitleArr.append("CHASSIS #")
            fieldTitleArr.append("CHASSIS IEP SCAC")
            
            fieldTitleArr.append("empty")
            fieldTitleArr.append("blank")
            fieldTitleArr.append("LOCATION NAME")
            fieldTitleArr.append("LOCATION ADDRESS")
            fieldTitleArr.append("ZIP CODE")
            fieldTitleArr.append("CITY")
            fieldTitleArr.append("STATE")
            
            fieldDataArr.append("Street Turn Details")
            fieldDataArr.append(txtEPCompanyName.text!)
            fieldDataArr.append(txtEPScac.text!)
            fieldDataArr.append(txtMCCompanyName.text!)
            fieldDataArr.append(txtMCScac.text!)
            fieldDataArr.append(txtImportBookingNum.text!)
            fieldDataArr.append(txtExportBookingNum.text!)
            fieldDataArr.append(txtContNum.text!)
            fieldDataArr.append(txtChassisNum.text!)
            fieldDataArr.append(txtChassisIEPScac.text!)
            
            fieldDataArr.append("")
            fieldDataArr.append("Original Interchange Location")
            fieldDataArr.append(txtLocationName.text!)
            fieldDataArr.append(txtLocationAddress.text!)
            fieldDataArr.append(txtZipCode.text!)
            fieldDataArr.append(txtCity.text!)
            fieldDataArr.append(txtState.text!)
            
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let verifyDetailsVC = storyboard.instantiateViewController(withIdentifier: "VerifyStreetTurnDetailsViewController") as! VerifyStreetTurnDetailsViewController
            verifyDetailsVC.fieldTitleArr = fieldTitleArr
            verifyDetailsVC.fieldDataArr = fieldDataArr
            self.present(verifyDetailsVC, animated: true, completion: nil)
            
            
        }else if item.tag == 2 {
            //cancel button tapped
            self.navigationController?.popViewController(animated: true)
        }
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
        /*if (textField.returnKeyType==UIReturnKeyType.go)
        {
            textField.resignFirstResponder();
            //self.nextButtonTapped(UIButton());
            return false;
        }*/
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
