//
//  UIIAExhibitVC.swift
//  SIA
//
//  Created by Piyush Panchal on 7/12/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class UIIAExhibitVC:  UIViewController, UITableViewDataSource,
UITableViewDelegate,UITabBarDelegate{
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var uiiaExhibitTableView: UITableView!
    @IBOutlet weak var uiiaExhibitTabBar: UITabBar!
    var tabBarItemImageView: UIImageView!
    
    var alertTitle :String = "UIIA Exhibit A"
    var originFrom :String?
    var uiiaExhibitArray = [UIIAExhibit]()
    var isNoneUIIAExhibitSelected = false
    var selectedUIIAExhibitArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiiaExhibitTabBar.delegate = self
        self.callGetListUIIAExhibit()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //Added reset code here to solve the back button issue from release screen.
        uiiaExhibitArray = [UIIAExhibit]()
        selectedUIIAExhibitArray = [Int]()
        
    }
    
    func callGetListUIIAExhibit(){
        
        if !au.isInternetAvailable() {
            au.redirectToNoInternetConnectionView(target: self)
        }
        else
        {
            let applicationUtils : ApplicationUtils = ApplicationUtils()
            applicationUtils.showActivityIndicator(uiView: view)
            
            let urlToRequest = ac.BASE_URL + ac.GET_UIIA_EXHIBIT_LIST
            
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
                        au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: { action in
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
                    return
                }
                do{
                    
                    let nsResponse =  response as! HTTPURLResponse
                    let parsedData = try JSONSerialization.jsonObject(with: data!)
                    
                    
                    print(parsedData)
                    if nsResponse.statusCode == 200
                    {
                        
                        
                        if let _data = parsedData as? NSArray
                        {
                            DispatchQueue.main.sync {
                                self.uiiaExhibitArray = UIIAExhibitResponse.init(_data).uiiaExhibitArray
                                self.uiiaExhibitTableView.reloadData()
                                applicationUtils.hideActivityIndicator(uiView: self.view)
                                
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
                        au.showAlert(target: self, alertTitle: self.alertTitle, message: self.ac.ERROR_MSG,[UIAlertAction(title: "OK", style: .default, handler: { action in
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
                
                
            }
            task.resume()
            
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uiiaExhibitArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row > 0 && uiiaExhibitArray.count > 0{
            
            let cell = tableView.cellForRow(at: indexPath) as! UIIAExhibitTableViewCell
            let currentRowData = uiiaExhibitArray[indexPath.row - 1]
            
            if vu.isNotEmptyString(stringToCheck: cell.checkBoxLabel.text!) {
                
                //unchecked the cell
                cell.checkBoxLabel.text = ""
                
                if let index = selectedUIIAExhibitArray.index(of: currentRowData.ueId!){
                    selectedUIIAExhibitArray.remove(at: index)
                }
            }else{
                
                //p.refer: https://stackoverflow.com/questions/8755506/put-checkmark-in-the-left-side-of-uitableviewcell
                //checked
                cell.checkBoxLabel.text = "\u{2713}"
                selectedUIIAExhibitArray.append(uiiaExhibitArray[indexPath.row - 1].ueId!)
            }
            print(selectedUIIAExhibitArray)
           
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleReuseIdentifier") as! SIADetailsTitleTableViewCell
            cell.lblTitle.text  = "Equipment Condition (per UIIA Exhibit A)"
            cell.leftView.alpha = 1
            cell.selectionStyle = .none
            return cell
            
        }else{
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "dataReuseIdentifier") as! UIIAExhibitTableViewCell
            if uiiaExhibitArray.count > 0{
               
                let currentRowData = uiiaExhibitArray[indexPath.row - 1]
                
                cell.lblFieldName.text = currentRowData.item
                cell.lblFieldData.text = currentRowData.itemDesc
                if selectedUIIAExhibitArray.contains(currentRowData.ueId!){
                    //tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
                    cell.checkBoxLabel.text = "\u{2713}"
                }else{
                    cell.checkBoxLabel.text = ""
                }
            }
            
            return cell
        }
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //do our animations
        self.tabBarItemImageView = self.uiiaExhibitTabBar.subviews[item.tag].subviews.first as! UIImageView
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
            //continue button tapped
            if selectedUIIAExhibitArray.count <= 0{
                
                au.showAlert(target: self, alertTitle: self.alertTitle, message: "Please select at least one equipment condition or none",[UIAlertAction(title: "OK", style: .default, handler: nil)], completion: nil)
            }else{
                
                NotificationCenter.default.post(name: .selectedUIIAExhibits, object: self)
                self.dismiss(animated: true, completion: nil)
            }
            
            
        }else if item.tag == 2 {
            //cancel button tapped
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
