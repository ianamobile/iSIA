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
    
    var originFrom :String?
    var companyInfoArray  = [CompanyInfo]()
    var picker = UIPickerView()
    var ianaLocationCode : String?
    var splcLocationCode : String?
    let alertTitle :String = "STREET TURN"
    var nextScreenMessage :String = ""
    var tabBarItemImageView: UIImageView!
    
    //very imporant when street interchange/street turn re-initiated the request from the view page.
    var reInitiatedRequestDetails: InterchangeRequests?
    
    //logged in users information
    var role :String?
    var loggedInUserCompanyName :String?
    var loggedInUserScac :String?
    var memType :String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
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
        
        //if logged in user as MC
        role =  UserDefaults.standard.string(forKey: "role")
        loggedInUserCompanyName =  UserDefaults.standard.string(forKey: "companyName")
        loggedInUserScac =  UserDefaults.standard.string(forKey: "scac")
        if role == "SEC"{
            memType =  UserDefaults.standard.string(forKey: "memType")
        }
        
        if role == "MC" || (role == "SEC" && memType == "MC" || role == "IDD"){
            
            txtMCCompanyName.text = loggedInUserCompanyName
            txtMCScac.text = loggedInUserScac
            
            txtEPCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            txtEPCompanyName.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            
            //Go to next field on return key
            UITextField.connectFields(fields: [txtEPCompanyName, txtContNum, txtExportBookingNum, txtImportBookingNum, txtChassisNum])
        }else{
            
            txtEPCompanyName.text = loggedInUserCompanyName
            txtEPScac.text = loggedInUserScac
            
            txtMCCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            txtMCCompanyName.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
            
            //Go to next field on return key
            UITextField.connectFields(fields: [txtMCCompanyName, txtContNum, txtExportBookingNum, txtImportBookingNum, txtChassisNum])
        }
        
        
        txtChassisNum.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtChassisNum.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
       
        //Data Populated from the Reinititate Interchange request -tapped
        self.populateDataFromReInitiateInterchagneIfAny()
        
    }
    //Data Populated from the Reinititate Interchange request -tapped
    func populateDataFromReInitiateInterchagneIfAny(){
        if(self.originFrom == "reInitiateStreetTurnReqSegue"){
            
            
            txtEPCompanyName.text = reInitiatedRequestDetails?.epCompanyName
            txtEPScac.text = reInitiatedRequestDetails?.epScacs
            txtMCCompanyName.text = reInitiatedRequestDetails?.mcACompanyName
            txtMCScac.text = reInitiatedRequestDetails?.mcAScac
            
            txtContNum.text = reInitiatedRequestDetails?.contNum
            txtExportBookingNum.text = reInitiatedRequestDetails?.bookingNum
            txtImportBookingNum.text = reInitiatedRequestDetails?.importBookingNum
            
            txtChassisNum.text = reInitiatedRequestDetails?.chassisNum
            txtChassisIEPScac.text = reInitiatedRequestDetails?.iepScac
            
            txtZipCode.text = reInitiatedRequestDetails?.originLocZip
            txtLocationName.text = reInitiatedRequestDetails?.originLocNm
            txtLocationAddress.text = reInitiatedRequestDetails?.originLocAddr
            txtCity.text = reInitiatedRequestDetails?.originLocCity
            txtState.text = reInitiatedRequestDetails?.originLocState
            
            
        }
    }
    
    //method that check user has internet connected in mobile or not.
    override func viewDidAppear(_ animated: Bool)
    {
        if !au.isInternetAvailable()
        {
            au.redirectToNoInternetConnectionView(target: self)
        }else{
            super.viewDidAppear(animated)
            if(originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!) && originFrom! == "StreetTurn"){
                resetFields();
            }
           
        }
    }
    func resetFields(){
        print("reset form field.....")
        
        if role == "MC" || (role == "SEC" && memType == "MC") || role == "IDD"{
            txtEPCompanyName.text = ""
            txtEPScac.text = ""
            
            txtEPCompanyName.inputView = nil
            
        }else if role == "EP" || (role == "SEC" && memType == "EP") || role == "TPU"{
            txtMCCompanyName.text = ""
            txtMCScac.text = ""
            txtMCCompanyName.inputView = nil
        }
 
        txtContNum.text = ""
        
        txtExportBookingNum.text = ""
        txtImportBookingNum.text = ""
        txtChassisNum.text = ""
        txtChassisIEPScac.text = ""
        
        
        txtZipCode.text = ""
        txtLocationName.text = ""
        txtLocationAddress.text = ""
        txtCity.text = ""
        txtState.text = ""
        
        originFrom = ""
        companyInfoArray  = []
        
        picker = UIPickerView()
        
        ianaLocationCode = ""
        splcLocationCode = ""
        nextScreenMessage = ""
       
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == txtMCCompanyName || textField == txtEPCompanyName
        {
            if textField.text! != "" && !textField.text!.isAlphanumericWithHyphenAndSpace{
                
                au.showAlert(target: self, alertTitle: self.alertTitle, message: "Company name should contains alphanumeric value only.",[UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        if textField == self.txtMCCompanyName{
                            self.txtMCScac.text = ""
                            
                        }else if textField == self.txtEPCompanyName{
                            self.txtEPScac.text = ""
                        }
                        textField.text = ""
                        break
                    case .cancel:
                        
                        break
                        
                    case .destructive:
                        
                        break
                        
                    }})], completion: nil)
            }else{
                loadListCompanyNameAndSCACAsInput(textField)
            }
            
            
        }else if textField == txtChassisNum {
            txtChassisIEPScac.text = ""
        }
        
    }
    
    
    func loadListCompanyNameAndSCACAsInput(_ textField: UITextField){
        var role :String = ""
        if textField == txtMCCompanyName{
             self.txtMCScac.text = ""
             role = "MC"
        }else if textField == txtEPCompanyName{
             self.txtEPScac.text = ""
             role = "EP"
        }
        
        let txtValue: String = au.replaceWhiteSpaces(au.trimSpaceAndNewLine(stringToTrimIncludingNewLine: (textField.text!)))
        if vu.isNotEmptyString(stringToCheck: txtValue)  && txtValue.count >= 2
        {
            //make a web service call to fetch boes location based on user.
            if !au.isInternetAvailable() {
                au.redirectToNoInternetConnectionView(target: self)
            }
            else
            {
                let applicationUtils : ApplicationUtils = ApplicationUtils()
                applicationUtils.showActivityIndicator(uiView: view)
                
                let urlToRequest = ac.BASE_URL + ac.GET_LIST_COMPANYNAME_SCAC_URI + "?requestType=IR_REQUEST&role=\(role)&companyName=\(txtValue)"
                print(urlToRequest)
                
                
                let url = URL(string: urlToRequest)!
                
                let session = URLSession.shared
                let request = NSMutableURLRequest(url: url)
                
                request.httpMethod = "GET"
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                
                
                let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                    guard let _: Data = data, let _: URLResponse = response, error == nil else {
                        print("*****error")
                        DispatchQueue.main.sync {
                            
                            self.companyInfoArray = [CompanyInfo]()
                            //self.picker.reloadAllComponents()
                            textField.inputView = nil;
                            textField.resignFirstResponder()
                            
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    // below 1 lines are to set inputview as default keyboard
                                    textField.becomeFirstResponder()
                                    break
                                case .cancel:
                                    break
                                    
                                case .destructive:
                                    break
                                    
                                }})], completion: nil)
                        }
                        
                        
                        return
                    }
                    do{
                        let nsResponse =  response as! HTTPURLResponse
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        
                        print(parsedData)
                        
                        if nsResponse.statusCode == 200
                        {
                            
                            if let _data:NSArray   = parsedData as? NSArray
                            {
                                let companyDetails: Company  = Company(_data)
                                //print(companyDetails.companyInfoArray)
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
                                    }/*
                                    else {
                                        
                                        // below 3 lines are to set inputview as default keyboard
                                        textField.inputView = nil;
                                        textField.resignFirstResponder()
                                        textField.becomeFirstResponder()
                                    }*/
                                    //print("self.companyInfoArray : \(self.companyInfoArray.count)")
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                }
                                
                            }
                            
                        }else if let _data:[String:Any]   = parsedData as? [String:Any]
                        {
                            
                            //handle other response ..
                            let apiResponseMessage: APIResponseMessage  = APIResponseMessage(_data)
                            
                            DispatchQueue.main.sync {
                                
                                self.companyInfoArray = [CompanyInfo]()
                                //self.picker.reloadAllComponents()
                                textField.inputView = nil;
                                textField.resignFirstResponder()
                                
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                au.showAlert(target: self, alertTitle: self.alertTitle, message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: { action in
                                    switch action.style{
                                    case .default:
                                        // below 1 lines are to set inputview as default keyboard
                                        textField.becomeFirstResponder()
                                        break
                                    case .cancel:
                                        break
                                        
                                    case .destructive:
                                        break
                                        
                                    }})], completion:nil )
                                
                                
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            
                            self.companyInfoArray = [CompanyInfo]()
                            //self.picker.reloadAllComponents()
                            textField.inputView = nil;
                            textField.resignFirstResponder()
                            
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    // below 1 lines are to set inputview as default keyboard
                                    textField.becomeFirstResponder()
                                    break
                                case .cancel:
                                    break
                                    
                                case .destructive:
                                    break
                                    
                                }})], completion: nil)
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
    
    @objc func doneButtonClicked(_ sender: DesignableUITextField) {
        sender.resignFirstResponder()
        
        if sender == txtMCCompanyName{
            //picker selected row
            if vu.isNotEmptyString(stringToCheck: sender.text!)  && sender.text!.count >= 2 && self.companyInfoArray.count > 0 {
                let selectedRow: Int  = self.picker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    txtMCCompanyName.text = self.companyInfoArray[selectedRow].companyName
                    txtMCScac.text = self.companyInfoArray[selectedRow].scac
                    
                    //reset the fields
                    self.companyInfoArray = []
                    sender.inputView = nil
                }
            }
            
        }else if sender == txtEPCompanyName{
            //picker selected row
            if vu.isNotEmptyString(stringToCheck: sender.text!)  && sender.text!.count >= 2 && self.companyInfoArray.count > 0 {
                let selectedRow: Int  = self.picker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    txtEPCompanyName.text = self.companyInfoArray[selectedRow].companyName
                    txtEPScac.text = self.companyInfoArray[selectedRow].scac
                    
                    //reset the fields
                    self.companyInfoArray = []
                    sender.inputView = nil
                }
            }
            
        }else if sender == txtChassisNum{
            //populate the IEP SCAC details based on chassisText
            if (vu.isNotEmptyString(stringToCheck: sender.text!)){
                
                if !sender.text!.isAlphanumeric{
                    
                     au.showAlert(target: self, alertTitle: self.alertTitle, message: "Chassis ID should contains alphanumeric only.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                     sender.text = ""
                }else if sender.text != "ZZZZ999999"{
                
                    //API call to set IEP SCAC
                    setIEPSCACBasedOnChassisNum()
                }
                
            }
            
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
        label.font = UIFont(name: "Roboto", size: 14)
        label.numberOfLines = 0
        label.sizeToFit()
        
        // where data is an Array of String
        label.text = companyInfoArray[row].scac! + " - " + companyInfoArray[row].companyName!
    
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
   
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if vu.isNotEmptyString(stringToCheck: txtEPScac.text!){
              self.performSegue(withIdentifier: "searchOriginalLocSegue", sender: self)
        }else{
           au.showAlert(target: self, alertTitle: self.alertTitle, message: "Please enter Container Provider Name First.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "searchOriginalLocSegue"
        {
            let vc = segue.destination as! LocationSearchTableViewController
            vc.delegate = self
            vc.epScac =  self.txtEPScac.text
            vc.originFrom = ac.ORIGINAL_LOCATION
            
        }
       else if segue.identifier == "verifyDetailsSegue"{
        
            var fieldDataArr = [FieldInfo]()
        
            // in case of blank chassis id, system will populate ZZZZ999999 to identify MC Provided Chassis.
            if vu.isEmptyString(stringToCheck: txtChassisNum.text!){
                txtChassisNum.text = "ZZZZ999999"
                txtChassisIEPScac.text = ""
                nextScreenMessage = ""
            }
        
            /* Note: Please change index if you add in middle of array otherwise next screen will be disturbed */
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Street Turn Details")) //0
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER NAME", fieldData: txtEPCompanyName.text!)) //1
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER SCAC", fieldData: txtEPScac.text!)) //2
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S NAME", fieldData: txtMCCompanyName.text!)) //3
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S SCAC", fieldData: txtMCScac.text!))  //4
            fieldDataArr.append(FieldInfo(fieldTitle: "IMPORT B/L", fieldData: txtImportBookingNum.text!.uppercased()))  //5
            fieldDataArr.append(FieldInfo(fieldTitle: "EXPORT BOOKING #", fieldData: txtExportBookingNum.text!.uppercased()))  //6
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER #", fieldData: txtContNum.text!.uppercased())) //7
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS ID", fieldData: txtChassisNum.text!.uppercased())) //8
        
            if vu.isNotEmptyString(stringToCheck: txtChassisIEPScac.text!) && vu.isNotEmptyString(stringToCheck: nextScreenMessage) && nextScreenMessage.count > 0{
                fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: txtChassisIEPScac.text!.uppercased() + " - " + nextScreenMessage)) //9
            }else{
                fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: txtChassisIEPScac.text!.uppercased())) //9
            }
            fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //10
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Original Interchange Location")) //11
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: txtLocationName.text!)) //12
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: txtLocationAddress.text!)) //13
            fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: txtZipCode.text!)) //14
            fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: txtCity.text!)) //15
            fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: txtState.text!)) //16
        
        
            let vc = segue.destination as! VerifyDetailsViewController
            vc.fieldDataArr = fieldDataArr
            vc.originFrom = "StreetTurn"
            if findInitiater() == "MCA"{
                vc.isStreetInterchangeInitiatedByMCA = "Y"
            }else{
                vc.isStreetInterchangeInitiatedByMCA = "N"
            }
        
            }
      
    }
    func findInitiater() -> String {
        if (role?.uppercased() == "MC".uppercased() ||
            (role?.uppercased() == "SEC".uppercased() && memType?.uppercased() == "MC".uppercased()) ||
            role?.uppercased() == "IDD".uppercased()) && loggedInUserScac?.uppercased() == txtMCScac.text?.uppercased(){
            
            return "MCB"
            
        }else if(role?.uppercased() == "EP".uppercased() ||
            (role?.uppercased() == "SEC".uppercased() && memType?.uppercased() == "EP".uppercased()) ||
            role?.uppercased() == "TPU".uppercased()){
            return "EP"
        }else if(role?.uppercased() == "MC".uppercased() ||
            (role?.uppercased() == "SEC".uppercased() && memType?.uppercased() == "MC".uppercased()) ||
            role?.uppercased() == "IDD".uppercased()){
            return "MCA"
        }
        
        return ""
    }
    func findAndNavigateToTappedView(selectedLocation: IANALocationInfo, originFrom: String) {
        
        ianaLocationCode = selectedLocation.ianaCode
        splcLocationCode = selectedLocation.splcCode
        
        txtZipCode.text = selectedLocation.zip
        txtLocationName.text = selectedLocation.facilityName
        txtLocationAddress.text = selectedLocation.address
        txtCity.text = selectedLocation.city
        txtState.text = selectedLocation.state
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //do our animations
        self.tabBarItemImageView = self.streetTurnTabBar.subviews[item.tag].subviews.first as! UIImageView
        self.tabBarItemImageView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            let transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            
            // let rotation = CGAffineTransform.init(translationX: oldX, y: oldY - 5)
            self.tabBarItemImageView.transform = transform
            
        }, completion: { (value: Bool) in
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.tabBarItemImageView.transform = .identity
            }, completion: nil)
            
        })
        
        if item.tag == 1 {
            //next button tapped
            sendValidationRequestForStreetTurn()
            
        }else if item.tag == 2 {
            //cancel button tapped
            au.showAlert(target: self, alertTitle: self.alertTitle, message: "Are you sure want to cancel this request?",
                         [UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                 self.navigationController?.popViewController(animated: true)
                                break
                            case .cancel:
                                
                                break
                                
                            case .destructive:
                                
                                break
                                
                            }}),
                          UIAlertAction(title: "CANCEL", style: .default, handler: nil)
                            
                ], completion: nil)
            
           
        }
    }
    
    func validateStreetTurnFields() -> String {
        
        var retMsg : String = ""
        if vu.isEmptyString(stringToCheck: txtMCCompanyName.text!){
               retMsg = "Motor Carrier Name should not be blank."
        
        }else if vu.isEmptyString(stringToCheck: txtMCScac.text!){
            retMsg = "Please select valid Motor Carrier Name to populate SCAC."
        
        }else if txtMCScac.text!.count < 4 {
            retMsg = "Motor Carrier SCAC should be 4 characters long."
        
        }else if !txtMCScac.text!.isCharactersOnly{
            retMsg = "Motor Carrier SCAC should contains characters only."
            
        }else if vu.isEmptyString(stringToCheck: txtEPCompanyName.text!){
            retMsg = "Container Provider Name should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtEPScac.text!){
            retMsg = "Please select valid Container Provider Name to populate SCAC."
            
        }else if txtEPScac.text!.count > 2  && txtEPScac.text!.count < 4 {
            retMsg = "Container Provider SCAC should be 2-4 characters long."
            
        }else if !txtEPScac.text!.isCharactersOnly{
            retMsg = "Container Provider SCAC should contains characters only."
        
        }else if vu.isEmptyString(stringToCheck: txtContNum.text!){
            retMsg = "Container Number should not be blank."
            
        }else if !txtContNum.text!.isAlphanumeric{
            retMsg = "Container Number should contains alphanumeric only."
            
        }else if vu.isEmptyString(stringToCheck: txtExportBookingNum.text!){
            retMsg = "Export Booking Number should not be blank."
            
        }else if !txtExportBookingNum.text!.isAlphanumeric{
            retMsg = "Export Booking Number should contains alphanumeric only."
            
        }else if vu.isNotEmptyString(stringToCheck: txtImportBookingNum.text!) &&
                !txtImportBookingNum.text!.isAlphanumeric{
            retMsg = "Import Booking Number should contains alphanumeric only."
            
        }else if vu.isNotEmptyString(stringToCheck: txtChassisNum.text!) && !txtChassisNum.text!.isAlphanumeric{
            retMsg = "Chassis ID should contains alphanumeric only."
            
        }else if vu.isEmptyString(stringToCheck: txtZipCode.text!){
            retMsg = "Zip Code should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtLocationName.text!){
            retMsg = "Location Name should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtLocationAddress.text!){
            retMsg = "Location Address should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtCity.text!){
            retMsg = "City should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtState.text!){
            retMsg = "State should not be blank."
        
        }else if txtState.text!.count != 2 {
            retMsg = "State should be 2 characters long."
        
        }
        
        return retMsg
        
    }
    
    func sendValidationRequestForStreetTurn() {
        
        // resign first responder if any.
        if txtMCCompanyName.isFirstResponder
        {
            txtMCCompanyName.resignFirstResponder();
        }else if txtEPCompanyName.isFirstResponder
        {
            txtEPCompanyName.resignFirstResponder();
        }else if txtContNum.isFirstResponder
        {
            txtContNum.resignFirstResponder();
        }else if txtExportBookingNum.isFirstResponder
        {
            txtExportBookingNum.resignFirstResponder();
        }else if txtImportBookingNum.isFirstResponder
        {
            txtImportBookingNum.resignFirstResponder();
        }else if txtChassisNum.isFirstResponder
        {
            txtChassisNum.resignFirstResponder();
        }
        
        // validate Login fields..
        let resMsg : String = validateStreetTurnFields()
        
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else if resMsg.isEmpty
        {
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let jsonRequestObject: [String : Any] =
                [
                    "irRequestType":"StreetTurn",
                    "epScacs": au.trim(stringToTrim: txtEPScac.text!),
                    "mcAScac": au.trim(stringToTrim: txtMCScac.text!),
                    "contNum": au.trim(stringToTrim: txtContNum.text!),
                    "chassisNum": au.trim(stringToTrim: txtChassisNum.text!),
                    "importBookingNum": au.trim(stringToTrim: txtImportBookingNum.text!),
                    "bookingNum": au.trim(stringToTrim: txtExportBookingNum.text!),
                    "originLocZip": au.trim(stringToTrim: txtZipCode.text!),
                    "originLocNm": au.trim(stringToTrim: txtLocationName.text!),
                    "originLocAddr": au.trim(stringToTrim: txtLocationAddress.text!),
                    "originLocCity": au.trim(stringToTrim: txtCity.text!),
                    "originLocState": au.trim(stringToTrim: txtState.text!),
                    "accessToken": accessToken!
                    
            ]
            
            print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.VALIDATE_STREET_TURN_URI
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
                            au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                        
                        return
                    }
                    do{
                        let nsResponse =  response as! HTTPURLResponse
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        
                        print(parsedData)
                        
                        if let stValidationData:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stValidationData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    //Don't change the order - all data should set before the self.performSegue.....
                                    if apiResponseMessage.message != nil && vu.isNotEmptyString(stringToCheck: apiResponseMessage.message!) && apiResponseMessage.message! != "SUCCESS"{
                                        self.nextScreenMessage = apiResponseMessage.message!
                                    }
                                    self.performSegue(withIdentifier: "verifyDetailsSegue", sender: self)
                                    
                                }
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stValidationData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: self.alertTitle, message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                    
                                }
                                
                            }
                            
                        }
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                    }
                    
                }
                task.resume()
                
            }
            
            
        }else{
            
            //display toast message to the user.
            au.showAlert(target: self, alertTitle: self.alertTitle, message: resMsg,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            
            
        }
    }
    
    func setIEPSCACBasedOnChassisNum() {
        //make a web service call to fetch boes location based on user.
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let txtValue: String = au.replaceWhiteSpaces(au.trimSpaceAndNewLine(stringToTrimIncludingNewLine: (txtChassisNum.text!)))
            let urlToRequest = ac.BASE_URL + ac.GET_IPESCAC_BY_CHASSIS_ID_URI + "?chassisId=\(txtValue)"
            
            
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
                        au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        
                    }
                    return
                }
                do{
                    let nsResponse =  response as! HTTPURLResponse
                    let parsedData = try JSONSerialization.jsonObject(with: data!)
                    
                    print(parsedData)
                    
                    if nsResponse.statusCode == 200
                    {
                        
                        if let _data:[String : String]   = parsedData as? [String : String]
                        {
                            DispatchQueue.main.sync {
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                self.txtChassisIEPScac.text = _data["iepScac"]
                            }
                            
                        }
                        
                    }else if let _data:[String:Any]   = parsedData as? [String:Any]
                    {
                        
                        //handle other response ..
                        let apiResponseMessage: APIResponseMessage  = APIResponseMessage(_data)
                        
                        DispatchQueue.main.sync {
                            
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: self.alertTitle, message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                            
                            
                        }
                        
                    }
                    
                    
                } catch let error as NSError {
                    print("NSError ::",error)
                    DispatchQueue.main.sync {
                        
                        applicationUtils.hideActivityIndicator(uiView: self.view)
                        au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        
                    }
                    
                }
                
                
            }
            task.resume()
            
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtZipCode || textField == txtCity  || textField == txtState
                        || textField == txtLocationAddress || textField == txtLocationName
                            || textField == txtChassisIEPScac || textField == txtMCScac
                                || textField == txtEPScac
            
        {
            textField.resignFirstResponder()
            return false
            
        }else if ((role == "MC" || (role == "SEC" && memType == "MC") || role == "IDD") && textField == txtMCCompanyName){
            textField.resignFirstResponder()
            return false
            
        }else  if ((role == "EP" || (role == "SEC" && memType == "EP") || role == "TPU") && textField == txtEPCompanyName){
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField == txtMCCompanyName || textField == txtEPCompanyName
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 200
            
        }else if textField == txtMCScac || textField == txtEPScac
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 4
            
        }else if textField == txtContNum
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 11
            
        }else if textField == txtExportBookingNum || textField == txtImportBookingNum
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 45
            
        }else if textField == txtChassisNum
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 20
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField ==  txtChassisNum && vu.isNotEmptyString(stringToCheck: textField.text!) && textField.text != "ZZZZ999999"{
            //API call to set IEP SCAC
            setIEPSCACBasedOnChassisNum()
        }
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
