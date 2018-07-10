//
//  RequestPoolSearchResultVC.swift
//  SIA
//
//  Created by Piyush Panchal on 7/4/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class RequestPoolSearchResultVC: UITableViewController, SearchRequestPoolTableViewCellDelegate {

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var requestPoolDetailsTableView: UITableView!
    var searchRequestPoolDetailsArray = [SearchRequestPoolDetails]() //display result View to the user.
    
    var offset:Int = 1
    var limit: Int  = 10
    var totalPages = 1;
    
    //variables mapped with search SIA Lookup screen.
    var contNum :String?
    var mcScac :String?
    var epScac :String?
    var fromDate :String?
    var toDate :String?
    var originFrom :String?
    
    let alertTitle = "REQUEST POOL SEARCH"
    
    var lastOffsetCalled :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPoolDetailsTableView.dataSource = self
        requestPoolDetailsTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Added reset code here to solve the back button issue from release screen.
        searchRequestPoolDetailsArray = [SearchRequestPoolDetails]()
        offset = 1
        totalPages = 1;
        limit = 10
        lastOffsetCalled = 0
        
        loadMore()
        
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchRequestPoolDetailsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchRequestPoolTableViewCell", for: indexPath) as! SearchRequestPoolTableViewCell
        
        //this is used to mapped the delegate between the tableview cell and this controller. when user tapped to any menu it should be navigate to new view based on this below line.
        cell.delegate = self
        cell.selectionStyle = .none //table cell selection style changed to none
       
        if(searchRequestPoolDetailsArray.count != 0){
            
            cell.leftView.tag = searchRequestPoolDetailsArray[indexPath.row].naId
            
            cell.lblCreatedDate.text = searchRequestPoolDetailsArray[indexPath.row].createdDate
            cell.lblMCCompanyName.text = searchRequestPoolDetailsArray[indexPath.row].mcCompanyName
            cell.lblMCScac.text = searchRequestPoolDetailsArray[indexPath.row].mcScac
            cell.lblEPName.text = searchRequestPoolDetailsArray[indexPath.row].epCompanyName
            cell.lblEPScac.text = searchRequestPoolDetailsArray[indexPath.row].epScac
            cell.loadStatus.text = searchRequestPoolDetailsArray[indexPath.row].loadStatus
            cell.lblContNum.text = searchRequestPoolDetailsArray[indexPath.row].contNum
            cell.lblContType.text = searchRequestPoolDetailsArray[indexPath.row].contType
            cell.lblContSize.text = searchRequestPoolDetailsArray[indexPath.row].contSize
            cell.lblChassisType.text = searchRequestPoolDetailsArray[indexPath.row].chassisType
            cell.lblChassisSize.text = searchRequestPoolDetailsArray[indexPath.row].chassisSize
            cell.lblChasisNum.text = searchRequestPoolDetailsArray[indexPath.row].chassisNum
            cell.lblIEPScac.text = searchRequestPoolDetailsArray[indexPath.row].iepScac
            
            if(searchRequestPoolDetailsArray[indexPath.row].showDeleteBtn != "Y" ){
                cell.btnDelete.alpha = 0
            }else{
                cell.btnDelete.alpha = 1
            }
            
            if offset > lastOffsetCalled && indexPath.row == searchRequestPoolDetailsArray.count - 1 && totalPages >= offset
            {
                self.loadMore()
            }
        }
        return cell
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped..")
        self.performSegue(withIdentifier: "initiateInterchangeFromNotifAvailSegue", sender: searchRequestPoolDetailsArray[indexPath.row])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "initiateInterchangeFromNotifAvailSegue"
        {
            
            let vc = segue.destination as! StreetInterchangeViewController
            let selectedObject: SearchRequestPoolDetails = sender as! SearchRequestPoolDetails
            vc.searchRequestPoolDetails = selectedObject
            vc.originFrom = segue.identifier
            
        }
    }
    
    func deleteNotificationAvailRecord(sender: SearchRequestPoolTableViewCell, originFrom: String) {
        print("Delete button tapped.")
        
        au.showAlert(target: self, alertTitle: self.alertTitle, message: "Are you sure want to delete this record?",
                     [UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            self.callDeleteNotifAvailRecordAPI(sender: sender, originFrom: originFrom)
                            break
                        case .cancel:
                            
                            break
                            
                        case .destructive:
                            
                            break
                            
                        }}),
                      UIAlertAction(title: "CANCEL", style: .default, handler: nil)
                        
            ], completion: nil)
        
        
        
        
        
    }
    func callDeleteNotifAvailRecordAPI(sender: SearchRequestPoolTableViewCell, originFrom: String) {
        let naId = sender.leftView.tag
        
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            
            let urlToRequest = ac.BASE_URL + ac.DELETE_NOTIFAVAILREQUEST_BY_ID_URI + "?accessToken=\(accessToken!)&naId=\(naId)"
            
            print(urlToRequest)
            
            let url = URL(string: urlToRequest)!
            
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "DELETE"
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
                        
                        if let _data:[String : Any]   = parsedData as? [String : Any]
                        {
                            let apiResponseMessage: APIResponseMessage  = APIResponseMessage(_data)
                            DispatchQueue.main.sync {
                                
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                au.showAlert(target: self, alertTitle: self.alertTitle, message: apiResponseMessage.message!,[UIAlertAction(title: "OK", style: .default, handler: { action in
                                    switch action.style{
                                    case .default:
                                        //Reloading the whole page because deleted notification avail record. -Referesing the page.
                                        self.searchRequestPoolDetailsArray = [SearchRequestPoolDetails]()
                                        self.offset = 1
                                        self.totalPages = 1;
                                        self.limit = 10
                                        self.lastOffsetCalled = 0
                                        //referesh the page with first request.
                                        self.loadMore()
                                        
                                        break
                                        
                                    case .cancel:
                                        break
                                    case .destructive:
                                        break
                                    }})], completion: nil)
                                
                            }
                            
                            
                        }
                        
                    }
                    else if let _data:[String:Any]   = parsedData as? [String:Any]
                    {
                        //in case of error : handle other response ..
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
    
    func loadMore(){
        
        self.lastOffsetCalled = self.offset
        
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
           
            let urlToRequest = ac.BASE_URL + ac.GET_EQUIP_LIST_URI + "?accessToken=\(accessToken!)&containerNo=\(contNum ?? "")&epSCAC=\(epScac ?? "")&mcSCAC=\(mcScac ?? "")&startDate=\(fromDate ?? "")&endDate=\(toDate ?? "")&offset=\(offset)&limit=\(limit)"
            
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
                        
                        if let _data:[String : Any]   = parsedData as? [String : Any]
                        {
                            
                            if let _paginationData:[String : Int]   = _data["page"] as? [String : Int]
                            {
                                if self.offset == 1
                                {
                                    let pagination: Pagination  = Pagination(_paginationData)
                                    self.totalPages = pagination.totalPages ?? 1;
                                    
                                }
                                
                            }
                            if let _requestPoolSearchRecordList:NSArray   = _data["notificationAvailList"] as? NSArray
                            {
                                let listRequestPoolDetails: [SearchRequestPoolDetails]  = SearchRequestPoolDetailsResponse(_requestPoolSearchRecordList).searchRequestPoolDetailsArray
                                DispatchQueue.main.sync {
                                    
                                    for record in listRequestPoolDetails
                                    {
                                        self.searchRequestPoolDetailsArray.append(record)
                                        
                                    }
                                    
                                    self.offset = self.offset + 1
                                    
                                    self.requestPoolDetailsTableView.reloadData()
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                }
                            }
                            
                            
                        }
                        
                    }
                    else if let _data:[String:Any]   = parsedData as? [String:Any]
                    {
                        
                        //handle other response ..
                        let apiResponseMessage: APIResponseMessage  = APIResponseMessage(_data)
                        
                        DispatchQueue.main.sync {
                            
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: self.alertTitle, message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    self.navigationController?.popViewController(animated: true)
                                    break
                                    
                                case .cancel:
                                    break
                                case .destructive:
                                    break
                                }})], completion: nil)
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
}
