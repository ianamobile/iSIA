//
//  ViewStreetTurnDetailsVC.swift
//  SIA
//
//  Created by Piyush Panchal on 6/21/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit


class ViewStreetTurnDetailsVC: UIViewController, UITableViewDataSource,
UITableViewDelegate, UIViewControllerTransitioningDelegate, UITextFieldDelegate{

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var siaTableView: UITableView!
    @IBOutlet weak var floaty: Floaty!
    @IBOutlet weak var viewWorkFlowBtn: UIButton!
    let transition = CircularTransition()
    
    var fieldDataArr = [FieldInfo]()
    var alertTitle :String?
    var fieldDataTitle: String = ""
    var nextScreenMessage :String = ""
    var originFrom :String?
    var searchSIADetails :SearchSIADetails?  //get interchange record from this object.
    var res: GetInterChangeRequestDetails = GetInterChangeRequestDetails() //stored interchange request response to this variable.
    var uiiaExhibitStr :String = ""
    
    //logged in users information
    var role :String?
    var loggedInUserCompanyName :String?
    var loggedInUserScac :String?
    var memType :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if logged in user as MC
        role =  UserDefaults.standard.string(forKey: "role")
        loggedInUserCompanyName =  UserDefaults.standard.string(forKey: "companyName")
        loggedInUserScac =  UserDefaults.standard.string(forKey: "scac")
        if role == "SEC"{
            memType =  UserDefaults.standard.string(forKey: "memType")
        }
        
        if originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!){
            if originFrom == "StreetTurn"{
                
                alertTitle = "STREET TURN"
                fieldDataTitle = "Street Turn Details"
            }else{
                alertTitle = "STREET INTERCHANGE"
                fieldDataTitle = "Street Interchange Details"
            }
        }
        
        self.callGetInterchangeRequestAPI()
        
        viewWorkFlowBtn.layer.cornerRadius = viewWorkFlowBtn.frame.size.width / 2
        
        floaty.buttonImage = UIImage(named: "menu")
        floaty.plusColor = UIColor.white
        floaty.buttonColor = #colorLiteral(red: 0.9294, green: 0.3961, blue: 0.2, alpha: 1) /* #ed6533 */
        //floaty.backgroundColor = UIColor(named: "ED6533")
        floaty.overlayColor = UIColor.white /* #ed6533 */
        

        NotificationCenter.default.addObserver(self, selector: #selector(handleUIIAExhibitsClosing), name: .selectedUIIAExhibits , object: nil)
        
    }
    
    
    func getNumbers(array : [Int]) -> String {
        let stringArray = array.map{ String($0) }
        return stringArray.joined(separator: ",")
    }
    
    @objc func handleUIIAExhibitsClosing(notification: Notification){
        print("handleUIIAExhibitsClosing done..")
        
        let dataVC = notification.object as! UIIAExhibitVC
        print(dataVC.selectedUIIAExhibitArray)
        
        uiiaExhibitStr = getNumbers(array: dataVC.selectedUIIAExhibitArray)
        print(uiiaExhibitStr)
        performOperation(opt: self.ac.OPT_APPROVE)
        
    }
    
    func openRemarksPopup(opt :String){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "ADD REMARKS", message: "Would you like to enter remarks?", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            
            //let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            //textField.addConstraint(heightConstraint)
            textField.placeholder = "Enter remarks here."
            
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "CONTINUE", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if vu.isNotEmptyString(stringToCheck: (textField?.text!)!) &&  (textField?.text!.count)! > 0{
                self.res.interchangeRequests.remarks = (textField?.text!)!
            }else{
                self.res.interchangeRequests.remarks = ""
            }
            
            if(opt == self.ac.OPT_APPROVE){
                self.approveRequestHandler(opt)
                
            }else if(opt == self.ac.OPT_REJECT){
                self.rejectRequestHandler(opt)
                
            }else if(opt == self.ac.OPT_ONHOLD){
                self.onHoldRequestHandler(opt)
                
            }else if(opt == self.ac.OPT_REINSTATE){
                self.reInitiateRequestHandler(opt)
                
            }else if(opt == self.ac.OPT_CANCEL){
                self.cancelRequestHandler(opt)
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { [] (_) in
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func createApproveFloatyButton(){
        
        let floatyItem : FloatyItem = floaty.addItem(title: "Approve", handler: {_ in
            
            if self.res.inProcessWf.wfId != nil && self.res.inProcessWf.wfSeqType != nil && self.res.inProcessWf.wfSeqType == "MCB" && self.res.interchangeRequests.irRequestType == "StreetInterchange"{
                self.performSegue(withIdentifier: "selectUIIAExhibitViewSegue", sender: self)
                
            }else{
                 self.performOperation(opt: self.ac.OPT_APPROVE)
            }
            
        })
        
        floatyItem.buttonColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 0, alpha: 1) /* #006400 */
        floatyItem.iconImageView.image = UIImage(named: "approve")
        floatyItem.iconImageView.tintColor = UIColor.white
        floatyItem.titleColor = UIColor.black
        
    }
    func createCancelFloatyButton(){
        
        let floatyItem : FloatyItem = floaty.addItem(title: "Cancel Request",handler: {_ in
            self.performOperation(opt: self.ac.OPT_CANCEL)
        })
        
        
        floatyItem.buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floatyItem.titleColor = UIColor.black
        floatyItem.iconImageView.image = UIImage(named: "cancel_tab")
        floatyItem.iconImageView.tintColor = UIColor.white
        
    }
    func createRejectFloatyButton(){
        
        let floatyItem : FloatyItem = floaty.addItem(title: "Reject",handler: {_ in
            self.performOperation(opt: self.ac.OPT_REJECT)
        })
       
        
        floatyItem.buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floatyItem.titleColor = UIColor.black
        floatyItem.iconImageView.image = UIImage(named: "reject")
        floatyItem.iconImageView.tintColor = UIColor.white
        
    }
    
    func createOnHoldFloatyButton(){
        
        let floatyItem : FloatyItem = floaty.addItem(title: "On Hold",handler: {_ in
            self.performOperation(opt: self.ac.OPT_ONHOLD)
        })
        
        
        floatyItem.buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floatyItem.titleColor = UIColor.black
        floatyItem.iconImageView.image = UIImage(named: "onhold")
        floatyItem.iconImageView.tintColor = UIColor.white
        
    }
    
    func createReInstateFloatyButton(){
        
        let floatyItem : FloatyItem = floaty.addItem(title: "Re-Initiate Request",handler: {_ in
            self.reInitiateRequestHandler(self.ac.OPT_REINSTATE)
        })
        
        floatyItem.buttonColor = #colorLiteral(red: 0.3569, green: 0.7529, blue: 0.8706, alpha: 1) /* #5bc0de */
        floatyItem.titleColor = UIColor.black
        floatyItem.iconImageView.image = UIImage(named: "reinitiate")
        floatyItem.iconImageView.tintColor = UIColor.white
        
    }
    
    func performOperation(opt :String){
        self.openRemarksPopup(opt: opt)
    }
    
    func approveRequestHandler(_ opt :String){
        callInterchangeRequestOperationsAPI(opt: opt)
    }
    func cancelRequestHandler(_ opt :String){
        callInterchangeRequestOperationsAPI(opt: opt)
    }
    func onHoldRequestHandler(_ opt :String){
        callInterchangeRequestOperationsAPI(opt: opt)
    }
    
    func rejectRequestHandler(_ opt :String){
        callInterchangeRequestOperationsAPI(opt: opt)
    }
    
    func reInitiateRequestHandler(_ opt :String){
       //re initiate the request and open respectives form based on the irRequestType
        if(self.res.interchangeRequests.irRequestType == "StreetInterchange"){
            self.performSegue(withIdentifier: "reInitiateInterchangeSegue", sender: self)
        }else{
            self.performSegue(withIdentifier: "reInitiateStreetTurnReqSegue", sender: self)
        }
    }
    
    func callInterchangeRequestOperationsAPI(opt: String){
        
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else if res.interchangeRequests.irId! > 0
        {
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            
            
            let jsonRequestObject: [String : Any] =
                [
                    "irId": res.interchangeRequests.irId as Any,
                    "wfId": res.inProcessWf.wfId as Any,
                    "opt": opt,
                    "uiiaExhibitStr": uiiaExhibitStr,
                    "remarks": res.interchangeRequests.remarks as Any,
                    "accessToken": accessToken!
                    
               ]
            
            print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.INTERCHANGE_REQUEST_OPERATIONS
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
                            au.showAlert(target: self, alertTitle: self.alertTitle!, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                        
                        return
                    }
                    do{
                        let nsResponse =  response as! HTTPURLResponse
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        
                        print(parsedData)
                        
                        if let operationData:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(operationData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: self.alertTitle!, message: apiResponseMessage.message!,[UIAlertAction(title: "OK", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            //refresh the page again
                                            self.callGetInterchangeRequestAPI()
                                            break
                                        case .cancel:
                                            break
                                            
                                        case .destructive:
                                            break
                                            
                                        }})], completion: nil)
                                }
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(operationData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: self.alertTitle!, message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                    
                                }
                                
                            }
                            
                        }
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: self.alertTitle!, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                    }
                    
                }
                task.resume()
                
            }
            
            
        }
    }
    
    
    
    
    func resetFloatyButtons(){
        if floaty.items.count > 0{
            for floatyItem in floaty.items{
                floaty.removeItem(item: floatyItem)
            }
        }
        
    }
    
    func callGetInterchangeRequestAPI() {
      
        self.res = GetInterChangeRequestDetails()
        resetFloatyButtons()
        fieldDataArr = [FieldInfo]()
        
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            
            let jsonRequestObject: [String : Any] =
                [
                    "irId" : searchSIADetails?.irId! as Any,
                    "accessToken" : accessToken!
            ]
            
            print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.GET_INTERCHANGE_REQUEST_DETAILS
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
                            au.showAlert(target: self, alertTitle: self.alertTitle!, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                        
                        return
                    }
                    do{
                        let nsResponse =  response as! HTTPURLResponse
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        
                        print(parsedData)
                        
                        if let data:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                self.res  = GetInterChangeRequestDetails(data)
                               
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    
                                    /* Note: Please change index if you add in middle of array otherwise next screen will be disturbed */
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: self.fieldDataTitle)) //0
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER NAME", fieldData: self.res.interchangeRequests.epCompanyName!)) //1
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER SCAC", fieldData: self.res.interchangeRequests.epScacs!)) //2
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S NAME", fieldData: self.res.interchangeRequests.mcACompanyName!)) //3
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S SCAC", fieldData: self.res.interchangeRequests.mcAScac!))  //4
                                    if self.searchSIADetails?.irRequestType == "StreetInterchange" {
                                        
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER B'S NAME", fieldData: self.res.interchangeRequests.mcBCompanyName!)) //5
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER B'S SCAC", fieldData: self.res.interchangeRequests.mcBScac!))  //6
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "TYPE OF INTERCHANGE", fieldData: self.res.interchangeRequests.intchgType ?? ""))  //7
                                        
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER TYPE", fieldData: self.res.interchangeRequests.contType ?? "")) //8
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER SIZE", fieldData: self.res.interchangeRequests.contSize ?? "")) //9
                                        
                                    }
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "IMPORT B/L", fieldData: self.res.interchangeRequests.importBookingNum  ?? ""))  //10
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "EXPORT BOOKING #", fieldData: self.res.interchangeRequests.bookingNum!))  //11
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER #", fieldData: self.res.interchangeRequests.contNum!)) //12
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS #", fieldData: self.res.interchangeRequests.chassisNum  ?? "")) //13
                                    
                                   
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: self.res.interchangeRequests.iepScac ?? "")) //14
                                    
                                    if self.searchSIADetails?.irRequestType == "StreetInterchange" {
                                        
                                        
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS TYPE", fieldData: self.res.interchangeRequests.chassisType ?? "")) //15
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS SIZE", fieldData: self.res.interchangeRequests.chassisSize ?? "")) //16
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "GENSET #", fieldData: self.res.interchangeRequests.gensetNum ?? "")) //17
                                        
                                        
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //18
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Equipment Location")) //19
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: self.res.interchangeRequests.equipLocNm ?? "")) //20
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: self.res.interchangeRequests.equipLocAddr ?? "")) //21
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: self.res.interchangeRequests.equipLocZip ?? "")) //22
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: self.res.interchangeRequests.equipLocCity ?? "")) //23
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: self.res.interchangeRequests.equipLocState ?? "")) //24
                                        
                                    
                                    }
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //25
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Original Interchange Location")) //26
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: self.res.interchangeRequests.originLocNm!)) //27
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: self.res.interchangeRequests.originLocAddr!)) //28
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: self.res.interchangeRequests.originLocZip!)) //29
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: self.res.interchangeRequests.originLocCity!)) //30
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: self.res.interchangeRequests.originLocState!)) //31
                                    
                                    if self.searchSIADetails?.irRequestType == "StreetInterchange" && self.res.uiiaExhibitDataList.count > 0{
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //32
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Equipment Condition (per UIIA Exhibit A)")) //33
                                        for uiiaExhibit in self.res.uiiaExhibitDataList {
                                             self.fieldDataArr.append(FieldInfo(fieldTitle: uiiaExhibit.item!, fieldData: uiiaExhibit.item_desc!)) //34
                                        }
                                    }
                                    
                                    if self.searchSIADetails?.irRequestType == "StreetInterchange" && self.res.interchangeRequests.remarks != nil
                                            && vu.isNotEmptyString(stringToCheck: (self.res.interchangeRequests.remarks!)){
                                        
                                            let remarksArray :[String] =  self.res.interchangeRequests.remarks!.components(separatedBy: "||")
                                            self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //32
                                            self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Previous Comments")) //33
                                            for remarks in remarksArray {
                                                self.fieldDataArr.append(FieldInfo(fieldTitle: "fullDataView", fieldData: remarks)) //34
                                            }
                                        
                                        
                                    }
                                    self.siaTableView.reloadData()
                                    
                                    //set all action menu options based on the response.
                                    
                                    //this button will be shown to all users
                                    self.createReInstateFloatyButton()
                                    
                                    
                                    if self.res.loggedInUserEligibleForApproval != nil && self.res.loggedInUserEligibleForApproval! && self.res.interchangeRequests.status! == "PENDING"{
                                        
                                        if self.res.showCancelButtons != nil && self.res.showCancelButtons == "Y"{
                                            self.createCancelFloatyButton()
                                        }
                                        
                                        self.createApproveFloatyButton()
                                        
                                        if self.res.inProcessWf.wfId != nil && self.res.inProcessWf.wfSeqType == "MCA"{
                                            self.createOnHoldFloatyButton()
                                        }
                                        
                                        self.createRejectFloatyButton()
                                    
                                    }else {
                                        if self.res.interchangeRequests.status! == "PENDING"{
                                            if self.res.showCancelButtons != nil && self.res.showCancelButtons == "Y"{
                                                self.createCancelFloatyButton()
                                            }
                                        }
                                        
                                    }
                                    
                                    self.view.addSubview(self.floaty)
                                    
                                }
                                
                            }else{
                    
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(data)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    au.showAlert(target: self, alertTitle: self.alertTitle!, message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: self.alertTitle!, message: self.ac.ERROR_MSG ,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                    }
                    
                    
                }
                task.resume()
                
            }
            
            
        }
        
    
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewWorkFlowDetailsSegue"{
            let viewWorkFlowDetailsVC = segue.destination as! ViewWorkFlowDetailsVC
            viewWorkFlowDetailsVC.transitioningDelegate = self
            viewWorkFlowDetailsVC.modalPresentationStyle = .custom
            viewWorkFlowDetailsVC.res = self.res;
        
        }else if segue.identifier == "reInitiateStreetTurnReqSegue" {
            let vc = segue.destination as! StreetTurnRequestViewController
             vc.reInitiatedRequestDetails = self.res.interchangeRequests
             vc.originFrom = segue.identifier
            
        }else if segue.identifier == "reInitiateInterchangeSegue" {
            let vc = segue.destination as! StreetInterchangeViewController
            vc.reInitiatedRequestDetails = self.res.interchangeRequests
            vc.originFrom = segue.identifier
        }
      
    }
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = viewWorkFlowBtn.center
        transition.circleColor = viewWorkFlowBtn.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = viewWorkFlowBtn.center
        transition.circleColor = viewWorkFlowBtn.backgroundColor!
        
        return transition
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if fieldDataArr[indexPath.row].fieldTitle == "blank" || fieldDataArr[indexPath.row].fieldTitle == "empty"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleReuseIdentifier") as! SIADetailsTitleTableViewCell
            cell.lblTitle.text  = fieldDataArr[indexPath.row].fieldData
            if fieldDataArr[indexPath.row].fieldTitle == "empty"{
                cell.leftView.alpha = 0
            }else{
               cell.leftView.alpha = 1
            }
            // Configure the cell...
            
            return cell
        }else if fieldDataArr[indexPath.row].fieldTitle == "fullDataView" {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "fullDataViewReuseIdentifier") as! SIAFullDataViewTableViewCell
            cell.lblFieldData.text = fieldDataArr[indexPath.row].fieldData
            // Configure the cell...
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataReuseIdentifier") as! SIADetailsDataTableViewCell
            cell.lblFieldName.text = fieldDataArr[indexPath.row].fieldTitle
            cell.lblFieldData.text = fieldDataArr[indexPath.row].fieldData
            // Configure the cell...
            
            return cell
        }
        
    }
    

}
