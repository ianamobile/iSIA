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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyDetailsBar.delegate = self
        self.navigationItem.hidesBackButton = true
        if originFrom != nil && vu.isNotEmptyString(stringToCheck: originFrom!){
            if originFrom == "StreetTurn"{
                
                alertTitle = "STREET TURN"
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
            //submit button tapped
            if originFrom == "StreetTurn"{
                 submitStreetTurnRequest()
            }else{
                 submitStreetInterchangeRequest()
            }
           
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successViewSegue"
        {
            let vc = segue.destination as! SuccessViewController
            vc.message =  self.nextScreenMessage
            vc.originFrom = self.originFrom
            
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
        self.performSegue(withIdentifier: "successViewSegue", sender: self)
             
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleReuseIdentifier", for: indexPath) as! SIADetailsTitleTableViewCell
            cell.lblTitle.text  = fieldDataArr[indexPath.row].fieldData
            if fieldDataArr[indexPath.row].fieldTitle == "empty"{
                cell.leftView.alpha = 0
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
