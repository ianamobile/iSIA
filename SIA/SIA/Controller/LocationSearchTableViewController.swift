//
//  LocationSearchTableViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 5/31/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class LocationSearchTableViewController: UITableViewController, UISearchBarDelegate {
   
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var locationTableView: UITableView!
    //delegate used to send data back to previous controller
    weak var delegate: LocationSearchTableViewCellDelegate?
    var searchArr : [IANALocationInfo] = []
    
    var epScac :String?
    var originFrom :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.searchBar.addRobotoFontToSearchBar(targetSearchBar: searchBar)
        callSearchLocationAPI(searchValue: "dummy", originFrom: originFrom!)
        
        
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func callSearchLocationAPI(searchValue:String, originFrom:String){
        
        if ((vu.isNotEmptyString(stringToCheck: searchValue)  && searchValue.count >= 3)  || searchValue == "dummy")
        {
            var txtValue: String = au.replaceWhiteSpaces(au.trimSpaceAndNewLine(stringToTrimIncludingNewLine: (searchValue)))
            
            if txtValue == "dummy"{
                txtValue = "";
            }
            
            
            //make a web service call to fetch boes location based on user.
            
            if !au.isInternetAvailable() {
                au.redirectToNoInternetConnectionView(target: self)
            }
            else
            {
                let applicationUtils : ApplicationUtils = ApplicationUtils()
                applicationUtils.showActivityIndicator(uiView: view)
                
                var urlToRequest = ""
                if originFrom == ac.ORIGINAL_LOCATION && epScac != nil && vu.isNotEmptyString(stringToCheck: epScac!){
                    urlToRequest = ac.BASE_URL + ac.FETCH_LOCATION_LIST_URI + "?epScac=\(epScac!)&location=\(txtValue)"
                }else{
                    urlToRequest = ac.BASE_URL + ac.FETCH_LOCATION_LIST_URI + "?location=\(txtValue)"
                }
                //print(urlToRequest)
                
                
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
                            au.showAlert(target: self, alertTitle: "SEARCH LOCATION", message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
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
                                let locationDetails: LocationDetails  = LocationDetails(_data)
                                DispatchQueue.main.sync {
                                    self.searchArr = locationDetails.ianaLocationInfoArray
                                    //print("self.locationArray : \(self.locationArray.count)")
                                    applicationUtils.hideActivityIndicator(uiView: self.view)
                                    self.locationTableView.reloadData()
                                }
                                
                            }
                            
                        }else if let _data:[String:Any]   = parsedData as? [String:Any]
                        {
                            
                            //handle other response ..
                            let apiResponseMessage: APIResponseMessage  = APIResponseMessage(_data)
                            
                            DispatchQueue.main.sync {
                                self.searchArr = []
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                self.locationTableView.reloadData()
                                au.showAlert(target: self, alertTitle: "SEARCH LOCATION", message: apiResponseMessage.errors.errorMessage!,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                                
                            }
                            
                        }
                        
                        
                    } catch let error as NSError {
                        print("NSError ::",error)
                        DispatchQueue.main.sync {
                            applicationUtils.hideActivityIndicator(uiView: self.view)
                            au.showAlert(target: self, alertTitle: "SEARCH LOCATION", message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
                        }
                        
                    }
                    
                    
                }
                task.resume()
                
            }
            
        }
        
        
            
        
    
    }
    
    /*
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked...\(String(describing: searchBar.text))")
        
        self.view.endEditing(true)
        
        let searchText = searchBar.text!
        if (vu.isNotEmptyString(stringToCheck: searchText))
        {
            callSearchLocationAPI(searchValue: searchText)
            
        }else if(vu.isEmptyString(stringToCheck: searchText))
        {
            callSearchLocationAPI(searchValue: "")
            
        }
        
    }
 */
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("didchange: \(searchText)")
    
    
        if (vu.isNotEmptyString(stringToCheck: searchText)  && searchText.count >= 3)
        {
            if searchText != "" && !searchText.isAlphanumericWithHyphenAndSpace{
                
                au.showAlert(target: self, alertTitle: "SEARCH LOCATION", message: "Location Search should contains alphanumeric value only.",[UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        self.searchBar.text = ""
                        break
                    case .cancel:
                        
                        break
                        
                    case .destructive:
                        
                        break
                        
                    }})], completion: nil)
                
                
                
            }else{
                
               callSearchLocationAPI(searchValue: searchText, originFrom: self.originFrom!)
            }
            
            
        }else if vu.isEmptyString(stringToCheck: searchText){
            callSearchLocationAPI(searchValue: "dummy", originFrom: self.originFrom!)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArr.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! LocationSearchTableViewCell
        
        cell.selectionStyle = .none //table cell row lines removed.
      
        
        cell.lblLocationName.text = searchArr[indexPath.row].facilityName
        cell.lblCity.text = searchArr[indexPath.row].city
        cell.lblState.text = searchArr[indexPath.row].state
        cell.lblZipCode.text = searchArr[indexPath.row].zip
        cell.lblAddress.text = searchArr[indexPath.row].address
        cell.lblIanaCode.text = searchArr[indexPath.row].ianaCode
        cell.lblSplcCode.text = searchArr[indexPath.row].splcCode
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped..")
        delegate?.findAndNavigateToTappedView(selectedLocation: searchArr[indexPath.row], originFrom: self.originFrom!)
        
        self.navigationController?.popViewController(animated: true)
        
    }
  
}
