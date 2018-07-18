//
//  ValidationUtils.swift
//  UtilityMethodCreation
//
//  Created by Piyush Panchal on 7/31/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import Foundation


extension String {
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var isAlphanumericWithHyphen: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9-]", options: .regularExpression) == nil
    }
    var isAlphanumericWithHyphenAndSpace: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9- ]", options: .regularExpression) == nil
    }
    var isAlphanumericWithSpace: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
    }
    
    var isCharactersOnly: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]+", options: .regularExpression) == nil
    }
    
    
}	

public class ValidationUtils{
    
    static let EMPTY: String = ""
    
    class func isEmptyString(stringToCheck: String) -> Bool{
        return (stringToCheck.isEmpty ||  ApplicationUtils.trim(stringToTrim: stringToCheck).count == 0) ? true : false
    }
    
    class func isNotEmptyString(stringToCheck: String) -> Bool{
        return (stringToCheck.isEmpty ||  ApplicationUtils.trim(stringToTrim: stringToCheck).count == 0) ? false : true
    }
    
    class func isNotEmptyArray(array: [Any]) -> (retult: Bool, totalRecords: Int){
        return array.count > 0 ?  (true, array.count) : (false, 0);
    }
    
    
    class func isNotEmptyDictionary(dictionary: [String : Any]) -> (retult: Bool, totalRecords: Int){
        return dictionary.count > 0 ? (true, dictionary.count) : (false, 0);
    }
    
    class func isDictionaryValuePresent(dictionary: [String : Any], key: String) -> (retult: Bool, dictionaryValue: Any){
        if isNotEmptyDictionary(dictionary: dictionary).retult {
            if dictionary[key] != nil
            {
                return (true , dictionary[key] as Any)
            }
        }
        return (false , EMPTY)
        
    }
    
    class func isNumber(string: String) -> Bool{
        if Double(string) != nil
        {
            return true
        }
        return false
        
    }
    
    class func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    
    class func isEqualStringByIgnoreCase(string1: String, string2: String) -> Bool {
        return string1.caseInsensitiveCompare(string2) == ComparisonResult.orderedSame
        
    }
    class func isEqualString(string1: String, string2: String) -> Bool {
        return string1 == string2
    }
    
    class func isEqualStringByIgnoreCaseTrim(string1: String, string2: String) -> Bool {
        return ApplicationUtils.trim(stringToTrim: string1).caseInsensitiveCompare(ApplicationUtils.trim(stringToTrim: string2)) == ComparisonResult.orderedSame
        
    }
    
    class func isEqualStringTrim(string1: String, string2: String) -> Bool {
        return ApplicationUtils.trim(stringToTrim: string1) == ApplicationUtils.trim(stringToTrim: string2)
    }
    
    
    
    
    

}
