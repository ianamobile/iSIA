//
//  ListEPUsersTableVC.swift
//  SIA
//
//  Created by Piyush Panchal on 6/22/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class ListEPUsersTableVC: UITableViewController {

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    
    @IBOutlet weak var listEPUsersTableView: UITableView!
    var epUsersArray = [Profile]() //display result View to the user.
    
    var offset:Int = 1
    var limit: Int  = 10
    var totalPages = 1;
    var lastOffsetCalled :Int = 0
    let alertTitle:String = "LIST EP USERS"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listEPUsersTableView.dataSource = self
        listEPUsersTableView.delegate = self
     }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Added reset code here to solve the back button issue from release screen.
        epUsersArray = [Profile]()
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
        return epUsersArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listEPUsersTableViewCell", for: indexPath) as! ListEPUsersTableViewCell
        cell.selectionStyle = .none //table cell selection style changed to none
        
        
        cell.lblEPName.text = epUsersArray[indexPath.row].companyName?.uppercased()
        cell.lblSCAC.text = epUsersArray[indexPath.row].scac?.uppercased()
        cell.lblStatus.text = epUsersArray[indexPath.row].status?.uppercased()
        
        if epUsersArray[indexPath.row].status == "PENDING"{
            cell.actionImageView.image = UIImage(named: "pending_hourglass")
            cell.actionImageView.tintColor =  #colorLiteral(red: 0.9137, green: 0.549, blue: 0.1137, alpha: 1) /* #e98c1d */
            cell.leftView.backgroundColor = #colorLiteral(red: 0.9137, green: 0.549, blue: 0.1137, alpha: 1) /* #e98c1d */
        }else if epUsersArray[indexPath.row].status == "DISABLED"{
            
            cell.actionImageView.image = UIImage(named: "rejected_wf_black")
            cell.actionImageView.tintColor =  #colorLiteral(red: 0.502, green: 0.502, blue: 0.502, alpha: 1) /* #808080 */
            cell.leftView.backgroundColor =   #colorLiteral(red: 0.502, green: 0.502, blue: 0.502, alpha: 1) /* #808080 */
            
        }else if epUsersArray[indexPath.row].status == "REJECTED"{
            cell.actionImageView.image = UIImage(named: "rejected_wf_black")
            cell.actionImageView.tintColor =   #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
            cell.leftView.backgroundColor =  #colorLiteral(red: 0.851, green: 0.3255, blue: 0.3098, alpha: 1) /* #d9534f */
        }
            
            
        if offset > lastOffsetCalled && indexPath.row == epUsersArray.count - 1 && totalPages >= offset
        {
          self.loadMore()
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if epUsersArray[indexPath.row].status == "ACTIVE"{
            goToEPAccountBySCAC(epScac :epUsersArray[indexPath.row].scac!);
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func goToEPAccountBySCAC(epScac :String) {
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let accessToken =  UserDefaults.standard.string(forKey: "accessToken")
            
            let urlToRequest = ac.BASE_URL + ac.GET_TPU_TOKEN_BY_EP_URI + "?accessToken=\(accessToken!)&epScac=\(epScac)"
            
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
                    
                    if let loginData:[String: Any]   = parsedData as? [String : Any]
                    {
                        
                        if nsResponse.statusCode == 200
                        {
                            let userDetails: UserDetails  = UserDetails(loginData)
                           
                            DispatchQueue.main.sync {
                                
                                UserDefaults.standard.set(userDetails.accessToken!, forKey: "accessToken")
                                UserDefaults.standard.set(userDetails.companyName!, forKey: "companyName")
                                UserDefaults.standard.set(userDetails.scac, forKey: "scac")
                                UserDefaults.standard.set(userDetails.role!, forKey: "originFrom")
                                
                                UserDefaults.standard.set(userDetails.iniIntrchng, forKey: "iniIntrchng")
                                UserDefaults.standard.set(userDetails.iniIntrchngAndApprove, forKey: "iniIntrchngAndApprove")
                                
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                self.performSegue(withIdentifier: "dashboardSegue", sender: self)
                                
                            }
                            
                        }else{
                            
                            //handle other response ..
                            let apiResponseMessage: APIResponseMessage  = APIResponseMessage(loginData)
                            
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
            
            let urlToRequest = ac.BASE_URL + ac.LIST_EP_USERS_URI + "?accessToken=\(accessToken!)&offset=\(offset)&limit=\(limit)"
            
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
                            if let _epUserList:NSArray   = _data["epUserList"] as? NSArray
                            {
                                let listEPUsersArray: [Profile]  = ProfileResponse(_epUserList).epUsersArray
                                DispatchQueue.main.sync {
                                    
                                    for record in listEPUsersArray
                                    {
                                        self.epUsersArray.append(record)
                                        
                                    }
                                    
                                    self.offset = self.offset + 1
                                    
                                    self.listEPUsersTableView.reloadData()
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
