//
//  RequestPoolSearchVC.swift
//  SIA
//
//  Created by Piyush Panchal on 7/4/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import UIKit

class RequestPoolSearchVC: UIViewController,UITextFieldDelegate, UITabBarDelegate{
    
    // variables which are necessory for all the controllers
    typealias au = ApplicationUtils
    typealias vu = ValidationUtils
    let ac :AppConstants  = AppConstants()
    
    @IBOutlet weak var searchRequestPoolTabBar: UITabBar!
   
    @IBOutlet weak var txtContNum: DesignableUITextField!
    @IBOutlet weak var txtFromDate: DesignableUITextField!
    @IBOutlet weak var txtToDate: DesignableUITextField!
    @IBOutlet weak var txtMCScac: DesignableUITextField!
    @IBOutlet weak var txtEPScac: DesignableUITextField!

    
    let datePicker: UIDatePicker = UIDatePicker()
    var tabBarItemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchRequestPoolTabBar.delegate = self
        
        //Hiding back buttton
        self.navigationItem.hidesBackButton = true
        
        //delegate self to apply border focus changes
        txtContNum.delegate = self
        txtMCScac.delegate = self
        txtEPScac.delegate = self
        txtFromDate.delegate = self
        txtToDate.delegate = self
        
        
        self.createDatePicker(txtFromDate)
        self.createDatePicker(txtToDate)
        
        //Go to next field on return key
        UITextField.connectFields(fields: [txtContNum,  txtMCScac, txtEPScac , txtFromDate, txtToDate])
       
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
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //do our animations
        self.tabBarItemImageView = self.searchRequestPoolTabBar.subviews[item.tag].subviews.first as! UIImageView
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
            
            if role == "TPU" && epScac != nil && vu.isNotEmptyString(stringToCheck: epScac!){
                self.performSegue(withIdentifier: "searchRequestPoolResultByTPUSegue", sender: self)
            }else{
                self.performSegue(withIdentifier: "searchRequestPoolResultSegue", sender: self)
            }
            
            
        }else if item.tag == 3 {
            //cancel button tapped
            self.navigationController?.popViewController(animated: true)
        
        }else if item.tag == 2{
            au.resignAllTextFieldResponder(textFieldsArray: [txtContNum,  txtMCScac, txtEPScac , txtFromDate, txtToDate])
            //reset form fields
            txtContNum.text  = ""
            txtMCScac.text = ""
            txtEPScac.text = ""
            txtFromDate.text = ""
            txtToDate.text = ""
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchRequestPoolResultByTPUSegue" || segue.identifier == "searchRequestPoolResultSegue"
        {
            let vc = segue.destination as! RequestPoolSearchResultVC
            
            vc.contNum  =  self.txtContNum.text
            vc.mcScac = self.txtMCScac.text
            vc.epScac = self.txtEPScac.text
            vc.fromDate = self.txtFromDate.text
            vc.toDate = self.txtToDate.text
            vc.originFrom = segue.identifier
            
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField == txtMCScac ||  textField == txtEPScac
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 4
            
        }else if textField == txtContNum
        {
            let newLength = text.count + string.count - range.length
            return newLength <= 11
            
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

