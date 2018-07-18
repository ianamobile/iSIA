//
//  StreetInterchangeViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 6/5/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class StreetInterchangeViewController: UIViewController , UITextFieldDelegate, UITabBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, LocationSearchTableViewCellDelegate {
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var streetInterchangeTabBar: UITabBar!
    
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
   
    var originFrom: String?
    //very important when street initiate created from notification avail search screen
    var searchRequestPoolDetails: SearchRequestPoolDetails?
    var naId : Int?
    
    //very imporant when street interchange/street turn re-initiated the request from the view page.
    var reInitiatedRequestDetails: InterchangeRequests?
    
    
    var companyInfoArray  = [CompanyInfo]()
    var typeOfInterchangeArray = [String]()
    var contTypeArray = [String]()
    var contSizeArray = [String]()
    var chassisTypeArray = [String]()
    var chassisSizeArray = [String]()
    var picker = UIPickerView()
    var typeOfInterchangePicker = UIPickerView()
    
    var contTypePicker = UIPickerView()
    var contSizePicker = UIPickerView()
    var chassisTypePicker = UIPickerView()
    var chassisSizePicker = UIPickerView()
    
    let alertTitle :String = "STREET INTERCHANGE"
    var nextScreenMessage :String = ""
    var tabBarItemImageView: UIImageView!
    
    var inputTextFieldsArray = [UITextField]()
    
    //logged in users information
    var role :String?
    var loggedInUserCompanyName :String?
    var loggedInUserScac :String?
    var memType :String?
    
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
        
        typeOfInterchangePicker.delegate = self
        typeOfInterchangePicker.dataSource = self
        
        streetInterchangeTabBar.delegate = self
        
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
        
        txtMCACompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtMCACompanyName.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        txtMCBCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtMCBCompanyName.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        txtEPCompanyName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtEPCompanyName.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        txtChassisNum.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtChassisNum.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
       
        
        //if logged in user as MC
        role =  UserDefaults.standard.string(forKey: "role")
        loggedInUserCompanyName =  UserDefaults.standard.string(forKey: "companyName")
        loggedInUserScac =  UserDefaults.standard.string(forKey: "scac")
        if role == "SEC"{
            memType =  UserDefaults.standard.string(forKey: "memType")
        }
        inputTextFieldsArray = [txtEPCompanyName, txtMCACompanyName, txtMCBCompanyName,
                                txtTypeOfInterchange, txtContType, txtContSize, txtImportBookingNum, txtExportBookingNum, txtContNum, txtChassisNum, txtChassisType, txtChassisSize,txtGensetNum, txtEquipZipCode, txtEquipLocationName, txtEquipLocationAddress, txtEquipCity, txtEquipState ]
        
        //Go to next field on return key
        UITextField.connectFields(fields: inputTextFieldsArray)
        
        //Setup page API call.
        setupPage()
        
        
    }
    func resetFields(){
        print("reset form field.....")
        
        txtEPCompanyName.text = ""
        txtEPCompanyName.inputView = nil
        txtEPScac.text = ""
        txtMCACompanyName.text = ""
        txtMCACompanyName.inputView = nil
        txtMCAScac.text = ""
        txtMCBCompanyName.text = ""
        txtMCBCompanyName.inputView = nil
        txtMCBScac.text = ""
        
        txtTypeOfInterchange.text = ""
        txtContType.text = ""
        txtContSize.text = ""
        txtImportBookingNum.text = ""
        txtExportBookingNum.text = ""
        txtContNum.text = ""
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
        
        //set picker value to first position when tried to create new request from success (3)page.
        typeOfInterchangePicker.selectRow(0, inComponent: 0, animated: true)
        contTypePicker.selectRow(0, inComponent: 0, animated: true)
        contSizePicker.selectRow(0, inComponent: 0, animated: true)
        chassisTypePicker.selectRow(0, inComponent: 0, animated: true)
        chassisSizePicker.selectRow(0, inComponent: 0, animated: true)
        
        nextScreenMessage = ""
        
        //searchRequestPoolDetails = SearchRequestPoolDetails()
        //reInitiatedRequestDetails = InterchangeRequests()
        
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
            
            let urlToRequest = ac.BASE_URL + ac.SETUP_PAGE_URI
            
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
                                
                                self.createTypeOfInterchangeDropDown(self.txtTypeOfInterchange)
                                self.createPickerViewDropDown(self.txtContType, self.contTypeArray, self.contTypePicker)
                                self.createPickerViewDropDown(self.txtContSize, self.contSizeArray, self.contSizePicker)
                                self.createPickerViewDropDown(self.txtChassisType, self.chassisTypeArray, self.chassisTypePicker)
                                self.createPickerViewDropDown(self.txtChassisSize, self.chassisSizeArray, self.chassisSizePicker)
                               
                                //Data Populated from the Notification Avail Search Record -tapped
                                self.populateDataFromNotifAvailSegueIfAny();
                                
                                //Data Populated from the Reinititate Interchange request -tapped
                                self.populateDataFromReInitiateInterchagneIfAny()
                                
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
    
    
    func createTypeOfInterchangeDropDown(_ sender: DesignableUITextField){
        
        self.typeOfInterchangeArray.append("LOAD/LOAD")
        self.typeOfInterchangeArray.append("LOAD/EMPTY")
        self.typeOfInterchangeArray.append("EMPTY/LOAD")
        
        self.typeOfInterchangePicker.reloadAllComponents()
        
        // Changing the input type to picker instead of keyboard
        if(self.typeOfInterchangeArray.count > 0) {
            
            // below 3 lines are to set inputview as picker and to see picker immediately
            sender.inputView = self.typeOfInterchangePicker
            
        }
        txtTypeOfInterchange.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    
    
    //Data Populated from the Reinititate Interchange request -tapped
    func populateDataFromReInitiateInterchagneIfAny(){
        if(self.originFrom == "reInitiateInterchangeSegue"){
            
            
            txtEPCompanyName.text = reInitiatedRequestDetails?.epCompanyName
            txtEPScac.text = reInitiatedRequestDetails?.epScacs
            txtMCACompanyName.text = reInitiatedRequestDetails?.mcACompanyName
            txtMCAScac.text = reInitiatedRequestDetails?.mcAScac
            txtMCBCompanyName.text = reInitiatedRequestDetails?.mcBCompanyName
            txtMCBScac.text = reInitiatedRequestDetails?.mcBScac
            
            txtTypeOfInterchange.text = reInitiatedRequestDetails?.intchgType
            txtContType.text = reInitiatedRequestDetails?.contType
            txtContSize.text = reInitiatedRequestDetails?.contSize
            txtImportBookingNum.text = reInitiatedRequestDetails?.importBookingNum
            txtExportBookingNum.text = reInitiatedRequestDetails?.bookingNum
            txtContNum.text = reInitiatedRequestDetails?.contNum
            txtChassisNum.text = reInitiatedRequestDetails?.chassisNum
            txtChassisIEPScac.text = reInitiatedRequestDetails?.iepScac
            
            txtChassisType.text = reInitiatedRequestDetails?.chassisType
            txtChassisSize.text = reInitiatedRequestDetails?.chassisSize
            txtGensetNum.text = reInitiatedRequestDetails?.gensetNum
            
            txtEquipZipCode.text = reInitiatedRequestDetails?.equipLocZip
            txtEquipLocationName.text = reInitiatedRequestDetails?.equipLocNm
            txtEquipLocationAddress.text = reInitiatedRequestDetails?.equipLocAddr
            txtEquipCity.text = reInitiatedRequestDetails?.equipLocCity
            txtEquipState.text = reInitiatedRequestDetails?.equipLocState
            
            txtOriginZipCode.text = reInitiatedRequestDetails?.originLocZip
            txtOriginLocationName.text = reInitiatedRequestDetails?.originLocNm
            txtOriginLocationAddress.text = reInitiatedRequestDetails?.originLocAddr
            txtOriginCity.text = reInitiatedRequestDetails?.originLocCity
            txtOriginState.text = reInitiatedRequestDetails?.originLocState
            
            setPickerDefaultValue(self.txtTypeOfInterchange, typeOfInterchangeArray, typeOfInterchangePicker, selectedValue: (reInitiatedRequestDetails?.intchgType)!)
            setPickerDefaultValue(self.txtContType, contTypeArray, contTypePicker, selectedValue: (reInitiatedRequestDetails?.contType)!)
            setPickerDefaultValue(self.txtContSize, contSizeArray, contSizePicker, selectedValue: (reInitiatedRequestDetails?.contSize)!)
            setPickerDefaultValue(self.txtChassisType, chassisTypeArray, chassisTypePicker, selectedValue: (reInitiatedRequestDetails?.chassisType)!)
            setPickerDefaultValue(self.txtChassisSize, chassisSizeArray, chassisSizePicker, selectedValue: (reInitiatedRequestDetails?.chassisSize)!)
            
            
        }
    }
    
    
     //Data Populated from the Notification Avail Search Record -tapped
    func populateDataFromNotifAvailSegueIfAny(){
      if(self.originFrom == "initiateInterchangeFromNotifAvailSegue"){
        
            self.txtEPCompanyName.text = searchRequestPoolDetails?.epCompanyName
            self.txtEPScac.text = searchRequestPoolDetails?.epScac
            self.txtMCACompanyName.text = searchRequestPoolDetails?.mcCompanyName
            self.txtMCAScac.text = searchRequestPoolDetails?.mcScac
        
            // editable mc b value for street interchange request - for MC login only
            if (role?.uppercased() == "MC".uppercased() ||
                (role?.uppercased() == "SEC".uppercased() && memType?.uppercased() == "MC".uppercased()) ||
                role?.uppercased() == "IDD".uppercased()){
                
                self.txtMCBCompanyName.text = loggedInUserCompanyName
                self.txtMCBScac.text = loggedInUserScac
            }
        
            self.txtContNum.text = searchRequestPoolDetails?.contNum
            self.txtChassisNum.text = searchRequestPoolDetails?.chassisNum
            self.txtChassisIEPScac.text = searchRequestPoolDetails?.iepScac
            self.txtGensetNum.text = searchRequestPoolDetails?.gensetNum
            self.naId = searchRequestPoolDetails?.naId
        
            //self.equipIanaLocationCode = searchRequestPoolDetails?.equipLocIanaCode
            //self.equipSplcLocationCode = searchRequestPoolDetails?.equipLocSplcCode
            self.txtEquipLocationName.text = searchRequestPoolDetails?.equipLocNm
            self.txtEquipLocationAddress.text = searchRequestPoolDetails?.equipLocAddr
            self.txtEquipCity.text  = searchRequestPoolDetails?.equipLocCity
            self.txtEquipState.text = searchRequestPoolDetails?.equipLocState
            self.txtEquipZipCode.text = searchRequestPoolDetails?.equipLocZip
        
            //self.originIanaLocationCode = searchRequestPoolDetails?.originLocIanaCode
            //self.originSplcLocationCode = searchRequestPoolDetails?.originLocSplcCode
            self.txtOriginLocationName.text = searchRequestPoolDetails?.originLocNm
            self.txtOriginLocationAddress.text = searchRequestPoolDetails?.originLocAddr
            self.txtOriginCity.text  = searchRequestPoolDetails?.originLocCity
            self.txtOriginState.text = searchRequestPoolDetails?.originLocState
            self.txtOriginZipCode.text = searchRequestPoolDetails?.originLocZip
        
            setPickerDefaultValue(self.txtContType, contTypeArray, contTypePicker, selectedValue: (searchRequestPoolDetails?.contType)!)
            setPickerDefaultValue(self.txtContSize, contSizeArray, contSizePicker, selectedValue: (searchRequestPoolDetails?.contSize)!)
            setPickerDefaultValue(self.txtChassisType, chassisTypeArray, chassisTypePicker, selectedValue: (searchRequestPoolDetails?.chassisType)!)
            setPickerDefaultValue(self.txtChassisSize, chassisSizeArray, chassisSizePicker, selectedValue: (searchRequestPoolDetails?.chassisSize)!)
        
        
      }
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
            if(originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!) && originFrom! == "AddNewStreetInterchange"){
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
        
        if vu.isNotEmptyString(stringToCheck: txtEPScac.text!){
            self.performSegue(withIdentifier: "searchOriginalLocSegue", sender: self)
        }else{
            au.showAlert(target: self, alertTitle: self.alertTitle, message: "Please enter Container Provider Name First.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == txtMCACompanyName || textField == txtMCBCompanyName || textField == txtEPCompanyName
        {
            if textField.text! != "" && !textField.text!.isAlphanumericWithHyphenAndSpace{
                
                au.showAlert(target: self, alertTitle: self.alertTitle, message: "Company name should contains alphanumeric value only.",[UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        if textField == self.txtMCACompanyName{
                            self.txtMCAScac.text = ""
                            
                        }else if textField == self.txtMCBCompanyName{
                            self.txtMCBScac.text = ""
                            
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
    
    //Auto complete the Company name and scac selection
    func loadListCompanyNameAndSCACAsInput(_ textField: UITextField){
        var role :String = ""
        if textField == txtMCACompanyName{
            self.txtMCAScac.text = ""
            role = "MC"
        }else if textField == txtMCBCompanyName{
            self.txtMCBScac.text = ""
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
        
        if sender == txtMCACompanyName{
            //picker selected row
            if vu.isNotEmptyString(stringToCheck: sender.text!)  && sender.text!.count >= 2 && self.companyInfoArray.count > 0 {
                let selectedRow: Int  = self.picker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    txtMCACompanyName.text = self.companyInfoArray[selectedRow].companyName
                    txtMCAScac.text = self.companyInfoArray[selectedRow].scac
                    
                    //reset the fields
                    self.companyInfoArray = []
                    sender.inputView = nil
                }
            }
            
        }else if vu.isNotEmptyString(stringToCheck: sender.text!) && sender.text!.count >= 2 && sender == txtMCBCompanyName{
            //picker selected row
            if self.companyInfoArray.count > 0 {
                let selectedRow: Int  = self.picker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    txtMCBCompanyName.text = self.companyInfoArray[selectedRow].companyName
                    txtMCBScac.text = self.companyInfoArray[selectedRow].scac
                    
                    //reset the fields
                    self.companyInfoArray = []
                    sender.inputView = nil
                }
            }
            
        }else if vu.isNotEmptyString(stringToCheck: sender.text!) && sender.text!.count >= 2 && sender == txtEPCompanyName{
            //picker selected row
            if self.companyInfoArray.count > 0 {
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
                    
                    au.showAlert(target: self, alertTitle: self.alertTitle, message: "Chassis Number should contains alphanumeric only.",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                    sender.text = ""
                }else if sender.text != "ZZZZ999999"{
                    
                    //API call to set IEP SCAC
                    setIEPSCACBasedOnChassisNum()
                }
                
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
            
        }else if sender == txtTypeOfInterchange{
            //picker selected row
            if self.typeOfInterchangeArray.count > 0 {
                let selectedRow: Int  = self.typeOfInterchangePicker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    sender.text = self.typeOfInterchangeArray[selectedRow]
                   
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
                pickerView.isHidden = false
            }
            else {
                pickerView.isHidden = true
            }
            return contTypeArray.count
            
        }else if pickerView == self.contSizePicker {
            
            if contSizeArray.count > 0 {
                pickerView.isHidden = false
            }
            else {
                pickerView.isHidden = true
            }
            return contSizeArray.count
            
        }else if pickerView == self.chassisTypePicker {
            
            if chassisTypeArray.count > 0 {
                pickerView.isHidden = false
            }
            else {
                pickerView.isHidden = true
            }
            return chassisTypeArray.count
            
        }else if pickerView == self.chassisSizePicker {
            
            if chassisSizeArray.count > 0 {
                pickerView.isHidden = false
            }
            else {
                pickerView.isHidden = true
            }
            return chassisSizeArray.count
            
        }else if pickerView == self.typeOfInterchangePicker {
            
            if typeOfInterchangeArray.count > 0 {
                pickerView.isHidden = false
            }
            else {
                pickerView.isHidden = true
            }
            return typeOfInterchangeArray.count
        }else{
            
            if companyInfoArray.count > 0 {
                pickerView.isHidden = false
            }
            else {
                pickerView.isHidden = true
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
        
        }else if pickerView == self.typeOfInterchangePicker{
            label.text = typeOfInterchangeArray[row]
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
        self.tabBarItemImageView = self.streetInterchangeTabBar.subviews[item.tag].subviews.first as! UIImageView
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
            sendValidationRequestForStreetInterchange()
           
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
    func findInitiater() -> String {
        if (role?.uppercased() == "MC".uppercased() ||
            (role?.uppercased() == "SEC".uppercased() && memType?.uppercased() == "MC".uppercased()) ||
                role?.uppercased() == "IDD".uppercased()) && loggedInUserScac?.uppercased() == txtMCBScac.text?.uppercased(){
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchOriginalLocSegue"
        {
            let vc = segue.destination as! LocationSearchTableViewController
            vc.delegate = self
            vc.epScac = txtEPScac.text
            vc.originFrom = ac.ORIGINAL_LOCATION
       
        }else if segue.identifier == "searchEquipmentLocSegue"
        {
            let vc = segue.destination as! LocationSearchTableViewController
            vc.delegate = self
            vc.originFrom = ac.EQUIPMENT_LOCATION
        }
        else if segue.identifier == "verifyDetailsSegue"{
            
            var fieldDataArr = [FieldInfo]()
            // in case of blank chassis number, system will populate ZZZZ999999 to identify MC Provided Chassis.
            if vu.isEmptyString(stringToCheck: txtChassisNum.text!){
                txtChassisNum.text = "ZZZZ999999"
                txtChassisIEPScac.text = ""
                nextScreenMessage = ""
            }
            
            /* Note: Please change index if you add in middle of array otherwise next screen will be disturbed */
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Street Interchange Details")) //0
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER NAME", fieldData: txtEPCompanyName.text!)) //1
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER SCAC", fieldData: txtEPScac.text!)) //2
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S NAME", fieldData: txtMCACompanyName.text!)) //3
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S SCAC", fieldData: txtMCAScac.text!))  //4
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER B'S NAME", fieldData: txtMCBCompanyName.text!)) //5
            fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER B'S SCAC", fieldData: txtMCBScac.text!))  //6
            fieldDataArr.append(FieldInfo(fieldTitle: "TYPE OF INTERCHANGE", fieldData: txtTypeOfInterchange.text!))  //7
            
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER TYPE", fieldData: txtContType.text!)) //8
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER SIZE", fieldData: txtContSize.text!)) //9
            
            fieldDataArr.append(FieldInfo(fieldTitle: "IMPORT B/L", fieldData: txtImportBookingNum.text!.uppercased()))  //10
            fieldDataArr.append(FieldInfo(fieldTitle: "EXPORT BOOKING #", fieldData: txtExportBookingNum.text!.uppercased()))  //11
            fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER #", fieldData: txtContNum.text!.uppercased())) //12
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS #", fieldData: txtChassisNum.text!.uppercased())) //13
            
            if vu.isNotEmptyString(stringToCheck: txtChassisIEPScac.text!) && vu.isNotEmptyString(stringToCheck: nextScreenMessage){
                fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: txtChassisIEPScac.text!.uppercased() + " - " + nextScreenMessage)) //14
            }else{
                fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: txtChassisIEPScac.text!.uppercased())) //14
            }
            
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS TYPE", fieldData: txtChassisType.text!)) //15
            fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS SIZE", fieldData: txtChassisSize.text!)) //16
            fieldDataArr.append(FieldInfo(fieldTitle: "GENSET #", fieldData: txtGensetNum.text!.uppercased())) //17
            
            fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //18
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Equipment Location")) //19
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: txtEquipLocationName.text!)) //20
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: txtEquipLocationAddress.text!)) //21
            fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: txtEquipZipCode.text!)) //22
            fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: txtEquipCity.text!)) //23
            fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: txtEquipState.text!)) //24
            
            
            fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //25
            fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Original Interchange Location")) //26
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: txtOriginLocationName.text!)) //27
            fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: txtOriginLocationAddress.text!)) //28
            fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: txtOriginZipCode.text!)) //29
            fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: txtOriginCity.text!)) //30
            fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: txtOriginState.text!)) //31
            
    
            
            let vc = segue.destination as! VerifyDetailsViewController
            vc.fieldDataArr = fieldDataArr
            vc.originFrom = "StreetInterchange"
            if findInitiater() == "MCA"{
                vc.isStreetInterchangeInitiatedByMCA = "Y"
            }else{
                 vc.isStreetInterchangeInitiatedByMCA = "N"
            }
            vc.naId = self.naId
        }
        
    }
    func validateStreetInterchangeFields() -> String {
        
        var retMsg : String = ""
        if vu.isEmptyString(stringToCheck: txtEPCompanyName.text!){
            retMsg = "Container Provider Name should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtEPScac.text!){
            retMsg = "Please select valid Container Provider Name to populate SCAC."
            
        }else if txtEPScac.text!.count > 2  && txtEPScac.text!.count < 4 {
            retMsg = "Container Provider SCAC should be 2-4 characters long."
            
        }else if !txtEPScac.text!.isCharactersOnly{
            retMsg = "Container Provider SCAC should contains characters only."
            
        }else if vu.isEmptyString(stringToCheck: txtMCACompanyName.text!){
            retMsg = "Motor Carrier A'S Name should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtMCAScac.text!){
            retMsg = "Please select valid Motor Carrier A'S Name to populate SCAC."
            
        }else if txtMCAScac.text!.count < 4 {
            retMsg = "Motor Carrier A'S SCAC should be 4 characters long."
            
        }else if !txtMCAScac.text!.isCharactersOnly{
            retMsg = "Motor Carrier A'S SCAC should contains characters only."
            
        }else if vu.isEmptyString(stringToCheck: txtMCBCompanyName.text!){
            retMsg = "Motor Carrier B'S Name should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtMCBScac.text!){
            retMsg = "Please select valid Motor Carrier B'S Name to populate SCAC."
            
        }else if txtMCBScac.text!.count < 4 {
            retMsg = "Motor Carrier B'S SCAC should be 4 characters long."
            
        }else if !txtMCBScac.text!.isCharactersOnly{
            retMsg = "Motor Carrier B'S SCAC should contains characters only."
            
        }else if vu.isEmptyString(stringToCheck: txtTypeOfInterchange.text!){
            retMsg = "Please select valid Type Of Interchange."
            
        }else if vu.isEmptyString(stringToCheck: txtContType.text!){
            retMsg = "Please select valid Container Type"
            
        }else if vu.isEmptyString(stringToCheck: txtContSize.text!){
            retMsg = "Please select valid Container Size"
            
        }else if vu.isEmptyString(stringToCheck: txtExportBookingNum.text!){
            retMsg = "Export Booking # should not be blank."

        }else if !txtExportBookingNum.text!.isAlphanumeric{
            retMsg = "Export Booking # should contains alphanumeric only."
        
        }else if vu.isEmptyString(stringToCheck: txtContNum.text!){
            retMsg = "Container Number should not be blank."
            
        }else if !txtContNum.text!.isAlphanumeric{
            retMsg = "Container Number should contains alphanumeric only."
            
        }else if vu.isNotEmptyString(stringToCheck: txtChassisNum.text!) && !txtChassisNum.text!.isAlphanumeric{
            retMsg = "Chassis Number should contains alphanumeric only."
            
        }else if vu.isNotEmptyString(stringToCheck: txtChassisNum.text!) && txtChassisNum.text! != "ZZZZ999999" && vu.isEmptyString(stringToCheck: txtChassisType.text!){
            retMsg = "Please select valid Chassis Type"
            
        }else if vu.isNotEmptyString(stringToCheck: txtChassisNum.text!) && txtChassisNum.text! != "ZZZZ999999" && vu.isEmptyString(stringToCheck: txtChassisSize.text!){
            retMsg = "Please select valid Chassis Size"
            
        }else if vu.isNotEmptyString(stringToCheck: txtGensetNum.text!) && !txtGensetNum.text!.isAlphanumeric{
            retMsg = "Genset Number should contains alphanumeric only."
            
        }else if vu.isEmptyString(stringToCheck: txtEquipZipCode.text!){
            retMsg = "Please select valid Equipment Location from the list"
            
        }else if vu.isEmptyString(stringToCheck: txtEquipLocationName.text!){
            retMsg = "Equipment Location Name should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtEquipLocationAddress.text!){
            retMsg = "Equipment Location Address should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtEquipCity.text!){
            retMsg = "Equipment City should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtEquipState.text!){
            retMsg = "Equipment State should not be blank."
            
        }else if txtEquipState.text!.count != 2 {
            retMsg = "Equipment State should be 2 characters long."
            
        }else if vu.isEmptyString(stringToCheck: txtOriginZipCode.text!){
            retMsg = "Please select valid Original Location from the list"
            
        }else if vu.isEmptyString(stringToCheck: txtOriginLocationName.text!){
            retMsg = "Original Location Name should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtOriginLocationAddress.text!){
            retMsg = "Original Location Address should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtOriginCity.text!){
            retMsg = "Original City should not be blank."
            
        }else if vu.isEmptyString(stringToCheck: txtOriginState.text!){
            retMsg = "Original State should not be blank."
            
        }else if txtOriginState.text!.count != 2 {
            retMsg = "Original State should be 2 characters long."
            
        }
        
        return retMsg
        
    }
    
    func sendValidationRequestForStreetInterchange() {
        
        // resign first responder if any.
        au.resignAllTextFieldResponder(textFieldsArray: inputTextFieldsArray)
        
        // validate Login fields..
        let resMsg : String = validateStreetInterchangeFields()
        
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
                    "irRequestType":"StreetInterchange",
                    "epScacs": au.trim(stringToTrim: txtEPScac.text!),
                    "mcAScac": au.trim(stringToTrim: txtMCAScac.text!),
                    "mcBScac": au.trim(stringToTrim: txtMCBScac.text!),
                    "intchgType": au.trim(stringToTrim: txtTypeOfInterchange.text!),
                    "contSize": au.trim(stringToTrim: txtContSize.text!),
                    "contType": au.trim(stringToTrim: txtContType.text!),
                    "contNum": au.trim(stringToTrim: txtContNum.text!),
                    "chassisSize": au.trim(stringToTrim: txtChassisSize.text!),
                    "chassisType": au.trim(stringToTrim: txtChassisType.text!),
                    "chassisNum": au.trim(stringToTrim: txtChassisNum.text!),
                    "importBookingNum": au.trim(stringToTrim: txtImportBookingNum.text!),
                    "bookingNum": au.trim(stringToTrim: txtExportBookingNum.text!),
                    "gensetNum": au.trim(stringToTrim: txtGensetNum.text!),
                    
                    "equipLocZip": au.trim(stringToTrim: txtEquipZipCode.text!),
                    "equipLocNm": au.trim(stringToTrim: txtEquipLocationName.text!),
                    "equipLocAddr": au.trim(stringToTrim: txtEquipLocationAddress.text!),
                    "equipLocCity": au.trim(stringToTrim: txtEquipCity.text!),
                    "equipLocState": au.trim(stringToTrim: txtEquipState.text!),
                    
                    "originLocZip": au.trim(stringToTrim: txtOriginZipCode.text!),
                    "originLocNm": au.trim(stringToTrim: txtOriginLocationName.text!),
                    "originLocAddr": au.trim(stringToTrim: txtOriginLocationAddress.text!),
                    "originLocCity": au.trim(stringToTrim: txtOriginCity.text!),
                    "originLocState": au.trim(stringToTrim: txtOriginState.text!),
                    "accessToken": accessToken!
                    
            ]
            
            print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.VALIDATE_STREET_INTERCHANGE_REQUEST_URI
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
        if textField == txtOriginZipCode || textField == txtOriginCity  || textField == txtOriginState
            || textField == txtOriginLocationAddress || textField == txtOriginLocationName
            || textField == txtChassisIEPScac || textField == txtMCAScac || textField == txtMCBScac
            || textField == txtEPScac
            
        {
            textField.resignFirstResponder()
            return false
        }
        else if(self.originFrom == "initiateInterchangeFromNotifAvailSegue"){
            if textField == txtEPCompanyName || textField == txtMCACompanyName || textField == txtContNum || textField == txtChassisNum || textField == txtGensetNum{
                textField.resignFirstResponder()
                return false
            }
            
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField == txtMCACompanyName || textField == txtMCBCompanyName || textField == txtEPCompanyName
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 200
            
        }else if textField == txtMCAScac || textField == txtMCBScac  || textField == txtEPScac
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
