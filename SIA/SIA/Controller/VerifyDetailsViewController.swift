//
//  VerifyDetailsViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 6/6/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class VerifyDetailsViewController: UIViewController, UITableViewDataSource,
                UITableViewDelegate, UITabBarDelegate, UINavigationBarDelegate {

    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    
    @IBOutlet weak var verifyDetailsBar: UITabBar!
    var fieldDataArr = [FieldInfo]()
    var alertTitle :String?
    var nextScreenMessage :String = ""
    var originFrom :String?
    var isStreetInterchangeInitiatedByMCA :String?
    var naId :Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyDetailsBar.delegate = self
        self.navigationItem.hidesBackButton = true
        if originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!){
            if originFrom == "StreetTurn"{
                
                alertTitle = "STREET TURN"
            }else if(originFrom == "AddNotifAvailRequest"){
                
                alertTitle = "ADD EQUIPMENT TO POOL"
            }else{
                alertTitle = "STREET INTERCHANGE"
            }
        }
        
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 1 {
            //edit button tapped
            self.navigationController?.popViewController(animated: true)
            
        }else if item.tag == 2 {
            
            au.showAlert(target: self, alertTitle: self.alertTitle!, message: "Are you sure want to submit this request?",
                     [UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            
                            //submit button tapped
                            if self.originFrom == "StreetTurn"{
                                self.submitStreetTurnRequest()
                            }else if(self.originFrom == "AddNotifAvailRequest"){
                                self.submitNotifAvailRequest()
                                
                            }else{
                                self.submitStreetInterchangeRequest()
                            }
                            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successViewSegue"
        {
            let vc = segue.destination as! SuccessViewController
            vc.message =  self.nextScreenMessage
            vc.originFrom = self.originFrom
            if originFrom == "StreetInterchange"{
                vc.isStreetInterchangeInitiatedByMCA = self.isStreetInterchangeInitiatedByMCA!
            }
            
        }
        
    }
    
    
    //Submit Notification of available equipment Request
    func submitNotifAvailRequest() {
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let jsonRequestObject: [String : Any] =
                [
                    "mcScac": au.trim(stringToTrim: fieldDataArr[4].fieldData!),
                    "epScac": au.trim(stringToTrim: fieldDataArr[2].fieldData!),
                    "loadStatus": au.trim(stringToTrim: fieldDataArr[5].fieldData!),
                    "contNum": au.trim(stringToTrim: fieldDataArr[6].fieldData!),
                    "contType": au.trim(stringToTrim: fieldDataArr[7].fieldData!),
                    "contSize": au.trim(stringToTrim: fieldDataArr[8].fieldData!),
                    "chassisNum": au.trim(stringToTrim: fieldDataArr[9].fieldData!),
                    "chassisType": au.trim(stringToTrim: fieldDataArr[11].fieldData!),
                    "chassisSize": au.trim(stringToTrim: fieldDataArr[12].fieldData!),
                    
                    
                    "gensetNum": au.trim(stringToTrim: fieldDataArr[13].fieldData!),
                    
                    "equipLocNm": au.trim(stringToTrim: fieldDataArr[16].fieldData!),
                    "equipLocAddr": au.trim(stringToTrim: fieldDataArr[17].fieldData!),
                    "equipLocZip": au.trim(stringToTrim: fieldDataArr[18].fieldData!),
                    "equipLocCity": au.trim(stringToTrim: fieldDataArr[19].fieldData!),
                    "equipLocState": au.trim(stringToTrim: fieldDataArr[20].fieldData!),
                    
                    
                    "originLocNm": au.trim(stringToTrim: fieldDataArr[23].fieldData!),
                    "originLocAddr": au.trim(stringToTrim: fieldDataArr[24].fieldData!),
                    "originLocZip": au.trim(stringToTrim: fieldDataArr[25].fieldData!),
                    "originLocCity": au.trim(stringToTrim: fieldDataArr[26].fieldData!),
                    "originLocState": au.trim(stringToTrim: fieldDataArr[27].fieldData!),
                    "accessToken": accessToken!
                    
                    
            ]
            
            print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.SAVE_NOTIF_AVAIL_URI
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
                        
                        if let stSubmittedData:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stSubmittedData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    self.nextScreenMessage = apiResponseMessage.message!
                                    self.performSegue(withIdentifier: "successViewSegue", sender: self)
                                }
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stSubmittedData)
                                
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
    
    
    //Submit Street Turn Request
    
    func submitStreetTurnRequest() {
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let jsonRequestObject: [String : Any] =
                [
                    "irRequestType":"StreetTurn",
                    "epScacs": au.trim(stringToTrim: fieldDataArr[2].fieldData!),
                    "contNum": au.trim(stringToTrim: fieldDataArr[7].fieldData!),
                    "chassisNum": au.trim(stringToTrim: fieldDataArr[8].fieldData!),
                    "importBookingNum": au.trim(stringToTrim: fieldDataArr[5].fieldData!),
                    "bookingNum": au.trim(stringToTrim: fieldDataArr[6].fieldData!),
                    "originLocZip": au.trim(stringToTrim: fieldDataArr[14].fieldData!),
                    "originLocNm": au.trim(stringToTrim: fieldDataArr[12].fieldData!),
                    "originLocAddr": au.trim(stringToTrim: fieldDataArr[13].fieldData!),
                    "originLocCity": au.trim(stringToTrim: fieldDataArr[15].fieldData!),
                    "originLocState": au.trim(stringToTrim: fieldDataArr[16].fieldData!),
                    "accessToken": accessToken!
                    
            ]
            
            print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.SAVE_STREET_TURN_URI
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
                        
                        if let stSubmittedData:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stSubmittedData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    self.nextScreenMessage = apiResponseMessage.message!
                                    self.performSegue(withIdentifier: "successViewSegue", sender: self)
                                }
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stSubmittedData)
                                
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
    
    //Submit Street interchange Request
    func submitStreetInterchangeRequest(){
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            var jsonRequestObject: [String : Any] =
                [
                    "irRequestType":"StreetInterchange",
                    "epScacs": au.trim(stringToTrim: fieldDataArr[2].fieldData!),
                    "mcAScac": au.trim(stringToTrim: fieldDataArr[4].fieldData!),
                    "mcBScac": au.trim(stringToTrim: fieldDataArr[6].fieldData!),
                    "intchgType": au.trim(stringToTrim: fieldDataArr[7].fieldData!),
                    
                   
                    "contType": au.trim(stringToTrim: fieldDataArr[8].fieldData!),
                    "contSize": au.trim(stringToTrim: fieldDataArr[9].fieldData!),
                    "importBookingNum": au.trim(stringToTrim: fieldDataArr[10].fieldData!),
                    "bookingNum": au.trim(stringToTrim: fieldDataArr[11].fieldData!),
                    "contNum": au.trim(stringToTrim: fieldDataArr[12].fieldData!),
                    "chassisNum": au.trim(stringToTrim: fieldDataArr[13].fieldData!),
                    "chassisType": au.trim(stringToTrim: fieldDataArr[15].fieldData!),
                    "chassisSize": au.trim(stringToTrim: fieldDataArr[16].fieldData!),
                    "gensetNum": au.trim(stringToTrim: fieldDataArr[17].fieldData!),
                    
                  
                    "equipLocNm": au.trim(stringToTrim: fieldDataArr[20].fieldData!),
                    "equipLocAddr": au.trim(stringToTrim: fieldDataArr[21].fieldData!),
                    "equipLocZip": au.trim(stringToTrim: fieldDataArr[22].fieldData!),
                    "equipLocCity": au.trim(stringToTrim: fieldDataArr[23].fieldData!),
                    "equipLocState": au.trim(stringToTrim: fieldDataArr[24].fieldData!),
                    
                   
                    "originLocNm": au.trim(stringToTrim: fieldDataArr[27].fieldData!),
                    "originLocAddr": au.trim(stringToTrim: fieldDataArr[28].fieldData!),
                    "originLocZip": au.trim(stringToTrim: fieldDataArr[29].fieldData!),
                    "originLocCity": au.trim(stringToTrim: fieldDataArr[30].fieldData!),
                    "originLocState": au.trim(stringToTrim: fieldDataArr[31].fieldData!),
                    "accessToken": accessToken!
             
            ]
            if(self.naId != nil && self.naId! > 0){
                jsonRequestObject ["naId"] = self.naId
            }
            print(jsonRequestObject)
            
            if let paramString = try? JSONSerialization.data(withJSONObject: jsonRequestObject)
            {
                let urlToRequest = ac.BASE_URL + ac.SAVE_INTERCHANGE_REQUEST_URL
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
                        
                        if let stSubmittedData:[String: Any]   = parsedData as? [String : Any]
                        {
                            
                            if nsResponse.statusCode == 200
                            {
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stSubmittedData)
                                
                                DispatchQueue.main.sync {
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    self.nextScreenMessage = apiResponseMessage.message!
                                    self.performSegue(withIdentifier: "successViewSegue", sender: self)
                                }
                                
                            }else{
                                
                                //handle other response ..
                                let apiResponseMessage: APIResponseMessage  = APIResponseMessage(stSubmittedData)
                                
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
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if fieldDataArr.count > 0 && fieldDataArr[indexPath.row].fieldTitle == "blank" || fieldDataArr[indexPath.row].fieldTitle == "empty"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleReuseIdentifier", for: indexPath) as! SIADetailsTitleTableViewCell
            cell.lblTitle.text  = fieldDataArr[indexPath.row].fieldData
            if fieldDataArr[indexPath.row].fieldTitle == "empty"{
                cell.leftView.alpha = 0
            }else{
                cell.leftView.alpha = 1
            }
            
            // Configure the cell...
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataReuseIdentifier", for: indexPath) as! SIADetailsDataTableViewCell
            cell.lblFieldName.text = fieldDataArr[indexPath.row].fieldTitle
            cell.lblFieldData.text = fieldDataArr[indexPath.row].fieldData
            // Configure the cell...
            
            return cell
        }
        
    }
    
}
