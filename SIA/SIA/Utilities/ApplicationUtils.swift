//
//  ApplicationUtils.swift
//  UtilityMethodCreation
//
//  Created by Piyush Panchal on 7/31/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

public class ApplicationUtils
{
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    

    class func trimSpaceAndNewLine(stringToTrimIncludingNewLine: String) -> String
    {
        return stringToTrimIncludingNewLine.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    class func replaceWhiteSpaces(_ input: String) -> String
    {
        return input.replacingOccurrences(of: " ", with: "%20")
    }
    class func trim(stringToTrim: String) -> String
    {
        return stringToTrim.trimmingCharacters(in: .whitespaces)
    }
    
    class func toUpperCase(stringToUpper: String) -> String{
        return stringToUpper.uppercased()
    }
    
    class func toLowerCase(stringToLower: String) -> String{
        return stringToLower.lowercased()
    }
    
    class func initCap(stringToCap: String) -> String {
        return stringToCap.capitalized(with:Locale.current)
    }
    
    
    class func getCurrentDate(dateFormat: String = "yyyy-MM-dd") -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return  formatter.string(from: date)
    }
    
    class func getCurrentDateTime(dateFormat: String = "yyyy-MM-dd hh:mm:ss") -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    class func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }

    class func checkInternetConnection(target: UIViewController,
                                       animation: Bool,
                                       alertActionTile: String = "OK",
                                       uiAlertActionHandler: ((UIAlertAction) -> Swift.Void)? = nil ,
                                       viewRenderCompletion: (() -> Swift.Void)? = nil) -> Bool
    {
        
        let title: String? = "BOES"
        let message : String = "Please check your internet connection and try again."
        
        
        let connected: Bool  = self.isInternetAvailable()
        if(!connected)
        {
            // preferredStyle can be .actionSheet
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            
            let defaultAction = UIAlertAction(title: alertActionTile, style: .default, handler: uiAlertActionHandler)
            alertController.addAction(defaultAction)
            
            target.present(alertController, animated: animation, completion: viewRenderCompletion)
            
        }
        
        return connected
    }
    
    /*
    class func getUIAlertControllerInstance(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "DVIR", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = UIColor.orange;
        
        return alert;
    }
    */
    class func showAlert(target: UIViewController, alertTitle: String, message: String, _ uiAlertAction: [UIAlertAction],completion: (() -> Swift.Void)? = nil){
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.view.tintColor = UIColor.orange;
        for alertAction in uiAlertAction{
            alert.addAction(alertAction)
        }
        target.present(alert, animated: true, completion: completion)
    }
    
    
    
    /*
    class func showToast(target: UIViewController, message : String) {
        //print("view.frame.size.height \(target.view.frame.size.height)")
        //print("view.frame.size.width \(target.view.frame.size.width)")
        let toastLabel = UILabel(frame: CGRect(x: 10 , y: target.view.frame.size.height-100, width: target.view.frame.size.width - 20, height: 70))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 3
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 6.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 3;
        toastLabel.clipsToBounds  =  true
        
        target.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 8, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
*/
    class func redirectToNoInternetConnectionView(target: UIViewController){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let noInternetController = storyboard.instantiateViewController(withIdentifier: "NoInternetViewController") as! NoInternetViewController
        target.present(noInternetController, animated: true, completion: nil)
    }

    class func showActivityIndicatory_2(uiView: UIView) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(actInd)
        
        actInd.startAnimating()
    }
    
    
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x:0, y:0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.layer.zPosition = 1
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
        activityIndicator.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    class func animateTextField(uiView: UIView, textField: UITextField, up: Bool)
    {
        //print("in animated...")
        let movementDistance:CGFloat = -80
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        uiView.frame = uiView.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

   class func focusTextField(uiView: UIView,textField: UITextField) {
        //self.animateTextField(uiView:  uiView, textField: textField, up:true)
        //textField.layer.shadowColor = UIColor.orange.cgColor
        textField.textColor = UIColor.orange

    }
    
    class func blurTextField(uiView: UIView,textField: UITextField) {
       // self.animateTextField(uiView:  uiView, textField: textField, up:false)
        //textField.layer.shadowColor = UIColor.gray.cgColor
        textField.textColor = UIColor.gray
        
    }
    
    

}
