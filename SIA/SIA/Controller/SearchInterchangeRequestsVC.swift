//
//  SearchInterchangeRequestsViewController.swift
//  SIA
//
//  Created by Piyush Panchal on 6/20/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class SearchInterchangeRequestsVC: UIViewController,UITextFieldDelegate, UITabBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var searchStreetInterchangeTabBar: UITabBar!
    
    @IBOutlet weak var txtContNum: DesignableUITextField!
    @IBOutlet weak var txtExportBookingNum: DesignableUITextField!
    @IBOutlet weak var txtFromDate: DesignableUITextField!
    @IBOutlet weak var txtToDate: DesignableUITextField!
    @IBOutlet weak var txtStatus: DesignableUITextField!
    @IBOutlet weak var txtScac: DesignableUITextField!
    @IBOutlet weak var lblScac: UILabel!
    
    let datePicker: UIDatePicker = UIDatePicker()
    var tabBarItemImageView: UIImageView!
    var picker = UIPickerView()
    var statusArray  = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        
        searchStreetInterchangeTabBar.delegate = self
        
        //Hiding back buttton
        self.navigationItem.hidesBackButton = true
        
        //delegate self to apply border focus changes
        txtContNum.delegate = self
        txtExportBookingNum.delegate = self
        txtFromDate.delegate = self
        txtToDate.delegate = self
        txtStatus.delegate = self
        txtScac.delegate = self
        
        self.createDatePicker(txtFromDate)
        self.createDatePicker(txtToDate)
        self.createStatusDropDown(txtStatus)
        
        
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtContNum, txtExportBookingNum, txtFromDate, txtToDate, txtStatus, txtScac])
        //if logged in user as MC
        let role =  UserDefaults.standard.string(forKey: "role")
        var memType :String? = ""
        if role == "SEC"{
            memType =  UserDefaults.standard.string(forKey: "memType")
        }
        
        txtScac.placeholder = "SEARCH BY SCAC"
        if role == "MC" || (role == "SEC" && memType == "MC"){
            lblScac.text = "CONTAINER PROVIDER SCAC"
           
        }else if role == "EP" || (role == "SEC" && memType == "EP") || role == "TPU" {
             lblScac.text = "MOTOR CARRIER SCAC"
        }
        
     }
    
     func createStatusDropDown(_ sender: DesignableUITextField){
        
        self.statusArray.append("SELECT STATUS")
        self.statusArray.append("PENDING")
        self.statusArray.append("APPROVED")
        self.statusArray.append("CANCELLED")
        self.statusArray.append("REJECTED")
        self.statusArray.append("ONHOLD")
        
        self.picker.reloadAllComponents()
        
        // Changing the input type to picker instead of keyboard
        if(self.statusArray.count > 0) {
            
            // below 3 lines are to set inputview as picker and to see picker immediately
            sender.inputView = self.picker
            
        }
        txtStatus.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
     }
    
    //Date picker view code start
    
    func createDatePicker(_ sender: DesignableUITextField){
        
        datePicker.datePickerMode = .date
        //assigning date picker to text field
        sender.inputView = datePicker
        sender.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    @objc func doneButtonClicked(_ sender: DesignableUITextField) {
        sender.resignFirstResponder()
        
        if sender == txtFromDate || sender == txtToDate{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            sender.text = dateFormatter.string(from: datePicker.date)
            
        }else if sender == txtStatus {
            //picker selected row
            if self.statusArray.count > 0 {
                let selectedRow: Int  = self.picker.selectedRow(inComponent: 0)
                if selectedRow >= 0{
                    txtStatus.text = self.statusArray[selectedRow]
                    
                }
            }
        }
    }
    //method that check user has internet connected in mobile or not.
    override func viewDidAppear(_ animated: Bool)
    {
        if !au.isInternetAvailable()
        {
            au.redirectToNoInternetConnectionView(target: self)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if statusArray.count > 0 {
            picker.isHidden = false
        }
        else {
            picker.isHidden = true
        }
        return statusArray.count
    
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto", size: 14)
        label.numberOfLines = 0
        label.sizeToFit()
        
        // where data is an Array of String
        label.text = statusArray[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //do our animations
        self.tabBarItemImageView = self.searchStreetInterchangeTabBar.subviews[item.tag].subviews.first as! UIImageView
        self.tabBarItemImageView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            let transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.tabBarItemImageView.transform = transform
            
        }, completion: { (value: Bool) in
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.tabBarItemImageView.transform = .identity
            }, completion: nil)
            
        })
        
        if item.tag == 1 {
            //next button tapped
            let role =  UserDefaults.standard.string(forKey: "role")
            let epScac =  UserDefaults.standard.string(forKey: "epSCAC")
            
            if role == "TPU" && epScac == nil{
                self.performSegue(withIdentifier: "searchResultByTPUSegue", sender: self)
            }else{
                self.performSegue(withIdentifier: "searchResultSegue", sender: self)
            }
           
            
        }else if item.tag == 3 {
            //cancel button tapped
            self.navigationController?.popViewController(animated: true)
            
        }else if item.tag == 2{
            au.resignAllTextFieldResponder(textFieldsArray: [txtContNum, txtExportBookingNum, txtFromDate, txtToDate, txtStatus, txtScac])
           
            //reset form fields
            txtContNum.text  = ""
            txtExportBookingNum.text = ""
            txtScac.text = ""
            txtStatus.text = ""
            txtFromDate.text = ""
            txtToDate.text = ""
            
             picker.selectRow(0, inComponent: 0, animated: true)
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResultSegue" || segue.identifier == "searchResultByTPUSegue"
        {
            let vc = segue.destination as! SearchInterchangeRequestResultVC
            
            vc.contNum  =  self.txtContNum.text
            vc.exportBookingNum = self.txtExportBookingNum.text
            vc.fromDate = self.txtFromDate.text
            vc.toDate = self.txtToDate.text
            if(self.txtStatus.text != "SELECT STATUS"){
                 vc.status = self.txtStatus.text
            }else{
                 vc.status = ""
            }
            vc.scac = self.txtScac.text
            vc.originFrom = segue.identifier
            
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField == txtScac
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 4
            
        }else if textField == txtContNum
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 11
            
        }else if textField == txtExportBookingNum
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 45
            
        }else if textField == txtFromDate || textField == txtToDate
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 10
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*if (textField.returnKeyType==UIReturnKeyType.go)
         {
         textField.resignFirstResponder();
         //self.nextButtonTapped(UIButton());
         return false;
         }*/
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
