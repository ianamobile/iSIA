//
//  AddNotifAvailRequestVC.swift
//  SIA
//
//  Created by Piyush Panchal on 7/5/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class AddNotifAvailRequestVC: UIViewController , UITextFieldDelegate, UITabBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, LocationSearchTableViewCellDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var addNotifAvailRequestTabBar: UITabBar!
    
    @IBOutlet weak var txtEPCompanyName: DesignableUITextField!
    @IBOutlet weak var txtEPScac: DesignableUITextField!
    @IBOutlet weak var txtMCCompanyName: DesignableUITextField!
    @IBOutlet weak var txtMCScac: DesignableUITextField!
    
    @IBOutlet weak var txtLoadStatus: DesignableUITextField!
    @IBOutlet weak var txtContNum: DesignableUITextField!
    @IBOutlet weak var txtContType: DesignableUITextField!
    @IBOutlet weak var txtContSize: DesignableUITextField!
    
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
    
    var originFrom: String?
    var companyInfoArray  = [CompanyInfo]()
    var loadStatusArray = [String]()
    var contTypeArray = [String]()
    var contSizeArray = [String]()
    var chassisTypeArray = [String]()
    var chassisSizeArray = [String]()
    var picker = UIPickerView()
    var loadStatusPicker = UIPickerView()
    
    var contTypePicker = UIPickerView()
    var contSizePicker = UIPickerView()
    var chassisTypePicker = UIPickerView()
    var chassisSizePicker = UIPickerView()
    
    let alertTitle :String = "ADD EQUIPMENT TO POOL"
    var nextScreenMessage :String = ""
    var tabBarItemImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        contTypePicker.delegate = self
        contTypePicker.dataSource = self
        
        contSizePicker.delegate = self
        contSizePicker.dataSource = self
        
        chassisTypePicker.delegate = self
        chassisTypePicker.dataSource = self
        
        chassisSizePicker.delegate = self
        chassisSizePicker.dataSource = self
        
        loadStatusPicker.delegate = self
        loadStatusPicker.dataSource = self
        
        addNotifAvailRequestTabBar.delegate = self
        
        txtEPCompanyName.delegate = self
        txtEPScac.delegate = self
        txtMCCompanyName.delegate = self
        txtMCScac.delegate = self
        
        txtLoadStatus.delegate = self
        txtContNum.delegate = self
        txtContType.delegate = self
        txtContSize.delegate = self
        
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
        
        txtMCCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtMCCompanyName.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        txtEPCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtEPCompanyName.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        txtChassisNum.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtChassisNum.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtEPCompanyName, txtMCCompanyName,
                                           txtLoadStatus, txtContNum, txtContType, txtContSize, txtChassisNum, txtChassisType, txtChassisSize,txtGensetNum, txtEquipZipCode, txtEquipLocationName, txtEquipLocationAddress, txtEquipCity, txtEquipState])
        
        //Setup page API call.
        setupPage()
        
        
    }
    func resetFields(){
        print("reset form field.....")
        
        txtEPCompanyName.text = ""
        txtEPScac.text = ""
        txtMCCompanyName.text = ""
        txtMCScac.text = ""
        
        txtLoadStatus.text = ""
        txtContNum.text = ""
        txtContType.text = ""
        txtContSize.text = ""
        
        txtChassisNum.text = ""
        txtChassisIEPScac.text = ""
        
        txtChassisType.text = ""
        txtChassisSize.text = ""
        txtGensetNum.text = ""
        
        txtEquipZipCode.text = ""
        txtEquipLocationName.text = ""
        txtEquipLocationAddress.text = ""
        txtEquipCity.text = ""
        txtEquipState.text = ""
        
        txtOriginZipCode.text = ""
        txtOriginLocationName.text = ""
        txtOriginLocationAddress.text = ""
        txtOriginCity.text = ""
        txtOriginState.text = ""
        
        originFrom = ""
        companyInfoArray  = []
        picker = UIPickerView()
        //TODO:: clear all picker view.
        nextScreenMessage = ""
        
    }
    
    func setupPage(){
        //make a web service call to fetch boes location based on user.
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let urlToRequest = ac.BASE_URL + ac.SETUP_PAGE
            
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
                        
                        if let _data:[String:Any]   = parsedData as? [String:Any]
                        {
                            let resObj: SetupPageResponse  = SetupPageResponse(_data)
                            DispatchQueue.main.sync {
                                
                                self.contTypeArray = resObj.contTypeArray
                                self.contSizeArray = resObj.contSizeArray
                                self.chassisTypeArray = resObj.chassisTypeArray
                                self.chassisSizeArray = resObj.chassisSizeArray
                                
                                self.createLoadStatusDropDown(self.txtLoadStatus)
                                self.createPickerViewDropDown(self.txtContType, self.contTypeArray, self.contTypePicker)
                                self.createPickerViewDropDown(self.txtContSize, self.contSizeArray, self.contSizePicker)
                                self.createPickerViewDropDown(self.txtChassisType, self.chassisTypeArray, self.chassisTypePicker)
                                self.createPickerViewDropDown(self.txtChassisSize, self.chassisSizeArray, self.chassisSizePicker)
                                
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                
                            }
                            
                        }
                        
                    }else if let _data:[String:Any]   = parsedData as? [String:Any]
                    {
                        
                        //handle other response ..
                        let apiResponseMessage: APIResponseMessage  = APIResponseMessage(_data)
                        
                        DispatchQueue.main.sync {
                            //self.searchArr = []
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            // self.locationTableView.reloadData()
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
    
    func createLoadStatusDropDown(_ sender: DesignableUITextField){
        
        self.loadStatusArray.append("LOAD/LOAD")
        self.loadStatusArray.append("LOAD/EMPTY")
        self.loadStatusArray.append("EMPTY/LOAD")
        
        self.loadStatusPicker.reloadAllComponents()
        
        // Changing the input type to picker instead of keyboard
        if(self.loadStatusArray.count > 0) {
            
            // below 3 lines are to set inputview as picker and to see picker immediately
            sender.inputView = self.loadStatusPicker
            
        }
        txtLoadStatus.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
   
    func setPickerDefaultValue(_ textField: DesignableUITextField, _ arrayValue :[String], _ pickerView: UIPickerView, selectedValue: String){
        
        if let index = arrayValue.index(of: selectedValue) {
            textField.text = selectedValue
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }else{
            //other case selected.
            textField.text = selectedValue
        }
    }
    
    //create picker view for multiple text fields.
    func createPickerViewDropDown(_ sender: DesignableUITextField,_ arrayValue:[String], _ pickerView: UIPickerView){
        
        pickerView.reloadAllComponents()
        
        // Changing the input type to picker instead of keyboard
        if(arrayValue.count > 0) {
            
            // below line is used to set inputview as picker and to see picker immediately
            sender.inputView = pickerView
            
        }
        sender.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    
    //method that check user has internet connected in mobile or not.
    override func viewDidAppear(_ animated: Bool)
    {
        if !au.isInternetAvailable()
        {
            au.redirectToNoInternetConnectionView(target: self)
        }else{
            super.viewDidAppear(animated)
            if(originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!) && originFrom! == "AddNewNotifAvailRequest"){
                resetFields();
            }
            
        }
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == txtMCCompanyName || textField == txtEPCompanyName
        {
            loadListCompanyNameAndSCACAsInput(textField)
            
        }else if textField == txtChassisNum {
            txtChassisIEPScac.text = ""
        }
        
    }
    
    //Auto complete the Company name and scac selection
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
                
                let urlToRequest = ac.BASE_URL + ac.GET_LIST_COMPANYNAME_SCAC + "?requestType=IR_REQUEST&role=\(role)&companyName=\(txtValue)"
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
            if self.companyInfoArray.count > 0 {
                let selectedRow: Int  = self.picker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    txtMCCompanyName.text = self.companyInfoArray[selectedRow].companyName
                    txtMCScac.text = self.companyInfoArray[selectedRow].scac
                }
            }
            
        }else if sender == txtEPCompanyName{
            //picker selected row
            if self.companyInfoArray.count > 0 {
                let selectedRow: Int  = self.picker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    txtEPCompanyName.text = self.companyInfoArray[selectedRow].companyName
                    txtEPScac.text = self.companyInfoArray[selectedRow].scac
                }
            }
            
        }else if sender == txtChassisNum{
            //populate the IEP SCAC details based on chassisText
            if vu.isNotEmptyString(stringToCheck: sender.text!) && sender.text != "ZZZZ999999"{
                //API call to set IEP SCAC
                setIEPSCACBasedOnChassisNum()
            }
            
            
        }else if sender == txtContType{
            //picker selected row
            if self.contTypeArray.count > 0 {
                let selectedRow: Int  = self.contTypePicker.selectedRow(inComponent: 0)
                if selectedRow >= 0 && self.contTypeArray[selectedRow].uppercased() != "Other".uppercased(){
                    sender.text = self.contTypeArray[selectedRow]
                    
                }else if(self.contTypeArray[selectedRow].uppercased() == "Other".uppercased()) && sender.inputView == contTypePicker{
                    sender.inputView = nil;
                    sender.text = "";
                    sender.placeholder = "ENTER CONTAINER TYPE MANUALLY."
                    sender.resignFirstResponder()
                    sender.becomeFirstResponder()
                    
                }else{
                    contTypePicker.reloadAllComponents()
                    sender.inputView = nil;
                    sender.placeholder = "SELECT CONTAINER TYPE."
                    sender.inputView = self.contTypePicker
                    
                }
            }
            
            
        }else if sender == txtContSize{
            //picker selected row
            if self.contSizeArray.count > 0 {
                let selectedRow: Int  = self.contSizePicker.selectedRow(inComponent: 0)
                if selectedRow >= 0 && self.contSizeArray[selectedRow].uppercased() != "Other".uppercased(){
                    sender.text = self.contSizeArray[selectedRow]
                    
                }else if(self.contSizeArray[selectedRow].uppercased() == "Other".uppercased()) && sender.inputView == contSizePicker{
                    sender.inputView = nil;
                    sender.text = "";
                    sender.placeholder = "ENTER CONTAINER SIZE MANUALLY."
                    sender.resignFirstResponder()
                    sender.becomeFirstResponder()
                    
                }else{
                    contSizePicker.reloadAllComponents()
                    sender.inputView = nil;
                    sender.placeholder = "SELECT CONTAINER SIZE."
                    sender.inputView = self.contSizePicker
                    
                }
                
            }
            
        }else if sender == txtChassisType{
            //picker selected row
            if self.chassisTypeArray.count > 0 {
                let selectedRow: Int  = self.chassisTypePicker.selectedRow(inComponent: 0)
                if selectedRow >= 0 && self.chassisTypeArray[selectedRow].uppercased() != "Other".uppercased(){
                    sender.text = self.chassisTypeArray[selectedRow]
                    
                }else if(self.chassisTypeArray[selectedRow].uppercased() == "Other".uppercased()) && sender.inputView == chassisTypePicker{
                    sender.inputView = nil;
                    sender.text = "";
                    sender.placeholder = "ENTER CHASSIS TYPE MANUALLY."
                    sender.resignFirstResponder()
                    sender.becomeFirstResponder()
                    
                }else{
                    chassisTypePicker.reloadAllComponents()
                    sender.inputView = nil;
                    sender.placeholder = "SELECT CHASSIS TYPE."
                    sender.inputView = self.chassisTypePicker
                    
                }
                
            }
            
        }else if sender == txtChassisSize{
            //picker selected row
            if self.chassisSizeArray.count > 0 {
                let selectedRow: Int  = self.chassisSizePicker.selectedRow(inComponent: 0)
                if selectedRow >= 0 && self.chassisSizeArray[selectedRow].uppercased() != "Other".uppercased(){
                    sender.text = self.chassisSizeArray[selectedRow]
                    
                }else if(self.chassisSizeArray[selectedRow].uppercased() == "Other".uppercased()) && sender.inputView == chassisSizePicker{
                    sender.inputView = nil;
                    sender.text = "";
                    sender.placeholder = "ENTER CHASSIS SIZE MANUALLY."
                    sender.resignFirstResponder()
                    sender.becomeFirstResponder()
                    
                }else{
                    chassisSizePicker.reloadAllComponents()
                    sender.inputView = nil;
                    sender.placeholder = "SELECT CHASSIS SIZE."
                    sender.inputView = self.chassisSizePicker
                    
                }
                
            }
            
        }else if sender == txtLoadStatus{
            //picker selected row
            if self.loadStatusArray.count > 0 {
                let selectedRow: Int  = self.loadStatusPicker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    sender.text = self.loadStatusArray[selectedRow]
                    
                }
            }
            
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == self.contTypePicker {
            
            if contTypeArray.count > 0 {
                picker.isHidden = false
            }
            else {
                picker.isHidden = true
            }
            return contTypeArray.count
            
        }else if pickerView == self.contSizePicker {
            
            if contSizeArray.count > 0 {
                picker.isHidden = false
            }
            else {
                picker.isHidden = true
            }
            return contSizeArray.count
            
        }else if pickerView == self.chassisTypePicker {
            
            if chassisTypeArray.count > 0 {
                picker.isHidden = false
            }
            else {
                picker.isHidden = true
            }
            return chassisTypeArray.count
            
        }else if pickerView == self.chassisSizePicker {
            
            if chassisSizeArray.count > 0 {
                picker.isHidden = false
            }
            else {
                picker.isHidden = true
            }
            return chassisSizeArray.count
            
        }else if pickerView == self.loadStatusPicker {
            
            if loadStatusArray.count > 0 {
                picker.isHidden = false
            }
            else {
                picker.isHidden = true
            }
            return loadStatusArray.count
        }else{
            
            if companyInfoArray.count > 0 {
                picker.isHidden = false
            }
            else {
                picker.isHidden = true
            }
            return companyInfoArray.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto", size: 14)
        label.numberOfLines = 0
        label.sizeToFit()
        
        if pickerView == self.contTypePicker {
            label.text = contTypeArray[row]
            
        }else if pickerView == self.contSizePicker {
            label.text = contSizeArray[row]
            
        }else if pickerView == self.chassisTypePicker {
            label.text = chassisTypeArray[row]
            
        }else if pickerView == self.chassisSizePicker {
            label.text = chassisSizeArray[row]
            
        }else if pickerView == self.loadStatusPicker{
            label.text = loadStatusArray[row]
        }else{
            label.text = companyInfoArray[row].scac! + " - " + companyInfoArray[row].companyName!
            
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //do our animations
        self.tabBarItemImageView = self.addNotifAvailRequestTabBar.subviews[item.tag].subviews.first as! UIImageView
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
            // sendValidationRequestForStreetInterchange()
            self.performSegue(withIdentifier: "verifyDetailsSegue", sender: self)
        }else if item.tag == 2 {
            //cancel button tapped
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchOriginalLocSegue"
        {
            let vc = segue.destination as! LocationSearchTableViewController
            vc.delegate = self
            vc.originFrom = ac.ORIGINAL_LOCATION
            
        }else if segue.identifier == "searchEquipmentLocSegue"
        {
            let vc = segue.destination as! LocationSearchTableViewController
            vc.delegate = self
            vc.originFrom = ac.EQUIPMENT_LOCATION
        }
        else if segue.identifier == "verifyDetailsSegue"{
            
            var fieldDataArr = [FieldInfo]()
            
            /* Note: Please change index if you add in middle of array otherwise next screen will be disturbed */
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Notification of Available Equipment Details")) //0
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER NAME", fieldData: txtEPCompanyName.text!)) //1
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER SCAC", fieldData: txtEPScac.text!)) //2
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER'S NAME", fieldData: txtMCCompanyName.text!)) //3
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER'S SCAC", fieldData: txtMCScac.text!))  //4
            fieldDataArr.append(FieldInfo(fieldTitle: "LOAD STATUS", fieldData: txtLoadStatus.text!))  //5
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER #", fieldData: txtContNum.text!)) //7
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER TYPE", fieldData: txtContType.text!)) //7
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER SIZE", fieldData: txtContSize.text!)) //7
            
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS #", fieldData: txtChassisNum.text!)) //8
            if vu.isNotEmptyString(stringToCheck: nextScreenMessage) && nextScreenMessage.count > 0{
                fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: txtChassisIEPScac.text! + nextScreenMessage)) //9
            }else{
                fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: txtChassisIEPScac.text!)) //9
            }
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS TYPE", fieldData: txtChassisType.text!)) //7
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS SIZE", fieldData: txtChassisSize.text!)) //7
            fieldDataArr.append(FieldInfo(fieldTitle: "GENSET #", fieldData: txtGensetNum.text!)) //7
            
            fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //10
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Equipment Location")) //11
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: txtEquipLocationName.text!)) //12
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: txtEquipLocationAddress.text!)) //13
            fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: txtEquipZipCode.text!)) //14
            fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: txtEquipCity.text!)) //15
            fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: txtEquipState.text!)) //16
            
            
            fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //17
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Original Interchange Location")) //18
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: txtOriginLocationName.text!)) //19
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: txtOriginLocationAddress.text!)) //20
            fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: txtOriginZipCode.text!)) //21
            fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: txtOriginCity.text!)) //22
            fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: txtOriginState.text!)) //23
            
            
            
            let vc = segue.destination as! VerifyDetailsViewController
            vc.fieldDataArr = fieldDataArr
            vc.originFrom = "AddNotifAvailRequest"
            
        }
        
    }
    //Find GIER IEP from the chassis Number provided by User
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
            let urlToRequest = ac.BASE_URL + ac.GET_IPESCAC_BY_CHASSIS_ID + "?chassisId=\(txtValue)"
            
            
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
        if textField == txtOriginZipCode || textField == txtOriginCity  || textField == txtOriginState
            || textField == txtOriginLocationAddress || textField == txtOriginLocationName
            || textField == txtChassisIEPScac || textField == txtMCScac || textField == txtEPScac
            
        {
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
            
        }else if textField == txtChassisNum
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 20
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*if (textField.returnKeyType==UIReturnKeyType.go)
         {
         textField.resignFirstResponder();
         self.nextButtonTapped(UIButton());
         return false;
         }
         */
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
