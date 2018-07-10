//
//  ViewStreetTurnDetailsVC.swift
//  SIA
//
//  Created by Piyush Panchal on 6/21/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class ViewStreetTurnDetailsVC: UIViewController, UITableViewDataSource,
UITableViewDelegate, UIViewControllerTransitioningDelegate{

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
    var nextScreenMessage :String = ""
    var originFrom :String?
    var searchSIADetails :SearchSIADetails?  //get interchange record from this object.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!){
            if originFrom == "StreetTurn"{
                
                alertTitle = "STREET TURN"
            }else{
                alertTitle = "STREET INTERCHANGE"
            }
        }
        
        self.callGetInterchangeRequestAPI()
        
        viewWorkFlowBtn.layer.cornerRadius = viewWorkFlowBtn.frame.size.width / 2
        
        floaty.buttonImage = UIImage(named: "menu")
        floaty.plusColor = UIColor.white
        floaty.buttonColor = #colorLiteral(red: 0.9294, green: 0.3961, blue: 0.2, alpha: 1) /* #ed6533 */
        //floaty.backgroundColor = UIColor(named: "ED6533")
        floaty.overlayColor = UIColor.white /* #ed6533 */
        
        floaty.addItem(title: "Approve", handler: {_ in
           // self.view.layer.backgroundColor = UIColor.blue.cgColor
        })
        floaty.addItem(title: "Cancel Request")
        floaty.addItem(title: "Reject")
        floaty.addItem(title: "On Hold")
        floaty.addItem(title: "Re-Initiate Request")
        
        floaty.items[0].buttonColor = #colorLiteral(red: 0.3608, green: 0.7216, blue: 0.3608, alpha: 1) /* #5cb85c */
        floaty.items[0].iconImageView.image = UIImage(named: "approve")
        floaty.items[0].iconImageView.tintColor = UIColor.white
        floaty.items[0].titleColor = UIColor.black
        
        floaty.items[1].buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floaty.items[1].titleColor = UIColor.black
        floaty.items[1].iconImageView.image = UIImage(named: "cancel_tab")
        floaty.items[1].iconImageView.tintColor = UIColor.white
        
        floaty.items[2].buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floaty.items[2].titleColor = UIColor.black
        floaty.items[2].iconImageView.image = UIImage(named: "reject")
        floaty.items[2].iconImageView.tintColor = UIColor.white
        
        
        floaty.items[3].buttonColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        floaty.items[3].titleColor = UIColor.black
        floaty.items[3].iconImageView.image = UIImage(named: "onhold")
        floaty.items[3].iconImageView.tintColor = UIColor.white
        
        
        floaty.items[4].buttonColor = #colorLiteral(red: 0.3569, green: 0.7529, blue: 0.8706, alpha: 1) /* #5bc0de */
        floaty.items[4].titleColor = UIColor.black
        floaty.items[4].iconImageView.image = UIImage(named: "reinitiate")
        floaty.items[4].iconImageView.tintColor = UIColor.white
        
    }
    
    func callGetInterchangeRequestAPI() {
      
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
                    "irId" :  162009, //searchSIADetails?.irId!, //274942, //,
                    "accessToken" : accessToken!
            ]
            
            //print(jsonRequestObject)
            
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
                                let res: GetInterChangeRequestDetails  = GetInterChangeRequestDetails(data)
                               
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    
                                    /* Note: Please change index if you add in middle of array otherwise next screen will be disturbed */
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Street Interchange Details")) //0
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER NAME", fieldData: res.interchangeRequests?.epCompanyName!)) //1
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER PROVIDER SCAC", fieldData: res.interchangeRequests?.epScacs!)) //2
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S NAME", fieldData: res.interchangeRequests?.mcACompanyName!)) //3
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER A'S SCAC", fieldData: res.interchangeRequests?.mcAScac!))  //4
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER B'S NAME", fieldData: res.interchangeRequests?.mcBCompanyName!)) //5
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "MOTOR CARRIER B'S SCAC", fieldData: res.interchangeRequests?.mcBScac!))  //6
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "TYPE OF INTERCHANGE", fieldData: res.interchangeRequests?.intchgType ?? ""))  //7
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER TYPE", fieldData: res.interchangeRequests?.contType ?? "")) //8
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER SIZE", fieldData: res.interchangeRequests?.contSize ?? "")) //9
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "IMPORT B/L", fieldData: res.interchangeRequests?.importBookingNum  ?? ""))  //10
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "EXPORT BOOKING#", fieldData: res.interchangeRequests?.bookingNum!))  //11
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CONTAINER #", fieldData: res.interchangeRequests?.contNum!)) //12
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS #", fieldData: res.interchangeRequests?.chassisNum  ?? "")) //13
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS IEP SCAC", fieldData: res.interchangeRequests?.iepScac ?? "")) //14
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS TYPE", fieldData: res.interchangeRequests?.chassisType ?? "")) //15
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CHASSIS SIZE", fieldData: res.interchangeRequests?.chassisSize ?? "")) //16
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "GENSET #", fieldData: res.interchangeRequests?.gensetNum ?? "")) //17
                                    
                                    if self.searchSIADetails?.irRequestType == "StreetInterchange" {
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //18
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Equipment Location")) //19
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: res.interchangeRequests?.equipLocNm ?? "")) //20
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: res.interchangeRequests?.equipLocAddr ?? "")) //21
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: res.interchangeRequests?.equipLocZip ?? "")) //22
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: res.interchangeRequests?.equipLocCity ?? "")) //23
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: res.interchangeRequests?.equipLocState ?? "")) //24
                                        
                                    
                                    }
                                    
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //25
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Original Interchange Location")) //26
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION NAME", fieldData: res.interchangeRequests?.originLocNm!)) //27
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "LOCATION ADDRESS", fieldData: res.interchangeRequests?.originLocAddr!)) //28
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "ZIP CODE", fieldData: res.interchangeRequests?.originLocZip!)) //29
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "CITY", fieldData: res.interchangeRequests?.originLocCity!)) //30
                                    self.fieldDataArr.append(FieldInfo(fieldTitle: "STATE", fieldData: res.interchangeRequests?.originLocState!)) //31
                                    
                                    if self.searchSIADetails?.irRequestType == "StreetInterchange" && res.uiiaExhibitDataList.count > 0{
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //32
                                        self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Equipment Condition (per UIIA Exhibit A)")) //33
                                        for uiiaExhibit in res.uiiaExhibitDataList {
                                             self.fieldDataArr.append(FieldInfo(fieldTitle: uiiaExhibit.item!, fieldData: uiiaExhibit.item_desc!)) //34
                                        }
                                    }
                                    
                                    if self.searchSIADetails?.irRequestType == "StreetInterchange" && res.interchangeRequests?.remarks != nil
                                            && vu.isNotEmptyString(stringToCheck: (res.interchangeRequests?.remarks!)!){
                                        
                                        if let remarksArray =  res.interchangeRequests?.remarks!.components(separatedBy: "|"){
                                            self.fieldDataArr.append(FieldInfo(fieldTitle: "empty", fieldData: "")) //32
                                            self.fieldDataArr.append(FieldInfo(fieldTitle: "blank", fieldData: "Previous Comments")) //33
                                            for remarks in remarksArray {
                                                self.fieldDataArr.append(FieldInfo(fieldTitle: "REMARKS", fieldData: remarks)) //34
                                            }
                                        }
                                        
                                        
                                    }
                                    self.siaTableView.reloadData()
                                   
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
        let viewWorkFlowDetailsVC = segue.destination as! ViewWorkFlowDetailsVC
        viewWorkFlowDetailsVC.transitioningDelegate = self
        viewWorkFlowDetailsVC.modalPresentationStyle = .custom
        
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataReuseIdentifier") as! SIADetailsDataTableViewCell
            cell.lblFieldName.text = fieldDataArr[indexPath.row].fieldTitle
            cell.lblFieldData.text = fieldDataArr[indexPath.row].fieldData
            // Configure the cell...
            
            return cell
        }
        
    }
    

}
