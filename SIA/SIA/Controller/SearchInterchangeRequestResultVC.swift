//
//  SearchInterchangeRequestResultVC.swift
//  SIA
//
//  Created by Piyush Panchal on 6/21/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SearchInterchangeRequestResultVC: UITableViewController {

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    
    @IBOutlet weak var siaDetailsTableView: UITableView!
    var searchSIADetailsArray = [SearchSIADetails]() //display result View to the user.
    
    var offset:Int = 1
    var limit: Int  = 10
    var totalPages = 1;
    
    //variables mapped with search SIA Lookup screen.
    var contNum :String?
    var exportBookingNum :String?
    var fromDate :String?
    var toDate :String?
    var status :String?
    var scac :String?
    var actionRequired :String?
    var originFrom :String?
    
    let alertTitle = "SEARCH INTERCHANGE REQUEST"
    
    var lastOffsetCalled :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        siaDetailsTableView.dataSource = self
        siaDetailsTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Added reset code here to solve the back button issue from release screen.
        searchSIADetailsArray = [SearchSIADetails]()
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
        return searchSIADetailsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchInterchangeRequestTableViewCell", for: indexPath) as! SearchInterchangeRequestTableViewCell
        
        cell.selectionStyle = .none //table cell selection style changed to none
        if searchSIADetailsArray.count > 0 {
            
            if searchSIADetailsArray[indexPath.row].status == "PENDING"{
                cell.leftView.backgroundColor = #colorLiteral(red: 0.9137, green: 0.549, blue: 0.1137, alpha: 1) /* #e98c1d */
                
            }else if searchSIADetailsArray[indexPath.row].status == "ONHOLD" ||
                searchSIADetailsArray[indexPath.row].status == "REJECTED" ||
                searchSIADetailsArray[indexPath.row].status == "CANCELLED" {
                cell.leftView.backgroundColor = #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
                
            }else if searchSIADetailsArray[indexPath.row].status == "APPROVED"{
                cell.leftView.backgroundColor = #colorLiteral(red: 0.3608, green: 0.7216, blue: 0.3608, alpha: 1) /* #5cb85c */
                
            }
            cell.lblCreatedDate.text = searchSIADetailsArray[indexPath.row].createdDate
            cell.lblRequestType.text = searchSIADetailsArray[indexPath.row].requestTypeTitle
            cell.lblStatus.text = searchSIADetailsArray[indexPath.row].status
            cell.lblActionRequired.text = searchSIADetailsArray[indexPath.row].actionRequired
            cell.lblContNum.text = searchSIADetailsArray[indexPath.row].contNum
            cell.lblExportBookingNum.text = searchSIADetailsArray[indexPath.row].bookingNum
            cell.lblEPName.text = searchSIADetailsArray[indexPath.row].epCompanyName
            cell.lblEPScac.text = searchSIADetailsArray[indexPath.row].epScacs
            cell.lblMCAName.text = searchSIADetailsArray[indexPath.row].mcACompanyName
            cell.lblMCAScac.text = searchSIADetailsArray[indexPath.row].mcAScac
            cell.lblMCBName.text = searchSIADetailsArray[indexPath.row].mcBCompanyName
            cell.lblMCBScac.text = searchSIADetailsArray[indexPath.row].mcBScac
            cell.lblActionDate.text = searchSIADetailsArray[indexPath.row].actionDate
            
            if searchSIADetailsArray[indexPath.row].status == "PENDING" || searchSIADetailsArray[indexPath.row].status == "APPROVED"{
               cell.lblActionDateTitle.text = "APPROVAL DATE"
                
            }else if searchSIADetailsArray[indexPath.row].status == "ONHOLD"{
              
                cell.lblActionDateTitle.text = "ONHOLD DATE"
                
            }else if searchSIADetailsArray[indexPath.row].status == "REJECTED"{
                cell.lblActionDateTitle.text = "REJECTION DATE"
                
            }else if searchSIADetailsArray[indexPath.row].status == "CANCELLED"{
                cell.lblActionDateTitle.text = "CANCELLED DATE"
                
            }
            
            if offset > lastOffsetCalled && indexPath.row == searchSIADetailsArray.count - 1 && totalPages >= offset
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
        
        if self.originFrom != "searchResultByTPUSegue"
        {
            if searchSIADetailsArray.count > 0
            {
                self.performSegue(withIdentifier: "viewStreetTurnDetails", sender: searchSIADetailsArray[indexPath.row])
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewStreetTurnDetails" {
            
            let vc = segue.destination as! ViewStreetTurnDetailsVC
            let selectedObject: SearchSIADetails = sender as! SearchSIADetails
            vc.searchSIADetails = selectedObject
            vc.originFrom = selectedObject.irRequestType
            
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
            let role =  UserDefaults.standard.string(forKey: "role")
            var memType :String? = ""
            if role == "SEC"{
                memType =  UserDefaults.standard.string(forKey: "memType")
            }
            
            var urlToRequest = ac.BASE_URL + ac.SIA_LOOKUP_URI + "?accessToken=\(accessToken!)&containerNo=\(contNum ?? "")&bookingNo=\(exportBookingNum ?? "")&startDate=\(fromDate ?? "")&endDate=\(toDate ?? "")&status=\(status ?? "")&offset=\(offset)&limit=\(limit)"
            
            if role == "MC" || (role == "SEC" && memType == "MC") || role == "IDD"{
                urlToRequest = urlToRequest + "&epSCAC=\(scac ?? "")"
            }else{
                 urlToRequest = urlToRequest + "&mcSCAC=\(scac ?? "")"
            }
            if actionRequired != nil && actionRequired == "Y"{
                urlToRequest = urlToRequest + "&actionRequired=Y"
            }
            
            print(urlToRequest)
            
            let url = URL(string: urlToRequest)!
            
            let session = URLSession.shared
            let request = NSMutableURLRequest(url: url)
            request.timeoutInterval = 600
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
                            if let _siaRecordList:NSArray   = _data["listInterchangeRequest"] as? NSArray
                            {
                                let listInterchangeRequest: [SearchSIADetails]  = SearchSIADetailsResponse(_siaRecordList).searchSIADetailsArray
                                DispatchQueue.main.sync {
                                    
                                    for record in listInterchangeRequest
                                    {
                                        self.searchSIADetailsArray.append(record)
                                        
                                    }
                                    
                                    self.offset = self.offset + 1
                                    
                                    self.siaDetailsTableView.reloadData()
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
                                    self.dismiss(animated: true, completion: nil)
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
