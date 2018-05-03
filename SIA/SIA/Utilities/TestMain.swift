//
//  TestMain.swift
//  UtilityMethodCreation
//
//  Created by Piyush Panchal on 7/31/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import Foundation



class TestMain {

    init() {
        
        print("------ string functions check----")
        print(ValidationUtils.isNotEmptyString(stringToCheck: "   "))
        
        print(ApplicationUtils.trim(stringToTrim: " ABC ddd   "))
        print(ApplicationUtils.trim(stringToTrim: "ABC  "))
        print(ApplicationUtils.trim(stringToTrim: "  Temp"))
        
        print(ApplicationUtils.trimSpaceAndNewLine(stringToTrimIncludingNewLine: "\r\n atest \t\n "))
        print(ApplicationUtils.toLowerCase(stringToLower: " ABCD122"))
        print(ApplicationUtils.toUpperCase(stringToUpper: "asfasf2 "))
        print(ApplicationUtils.initCap(stringToCap : " ABCD122"))
        
        print(ApplicationUtils.getCurrentDate())
        print(ApplicationUtils.getCurrentDateTime())
        
        print(ApplicationUtils.getCurrentDateTime(dateFormat: "yyyy-MM-dd hh:mm"))
        print(ApplicationUtils.getCurrentDate(dateFormat:  "MM/dd/yyyy"))
        
        var str: String = ""
        
        print(ValidationUtils.isNotEmptyString(stringToCheck: str))
        
        str = "User"
        print(ValidationUtils.isNotEmptyString(stringToCheck: str))
        
        var array = [String]()
        
        print(ValidationUtils.isNotEmptyArray(array: array))
        
        
        array.append("Vipul")
        print(ValidationUtils.isNotEmptyArray(array: array))
        
        var dictionary = [String : Any ]()
        print(ValidationUtils.isNotEmptyDictionary(dictionary: dictionary))
        
        dictionary["usrename"] = array [0]
        dictionary["age"] = 28
        
        print("dictionary - ",dictionary)
        print(ValidationUtils.isNotEmptyDictionary(dictionary: dictionary))
        
        print(ValidationUtils.isDictionaryValuePresent(dictionary: dictionary, key: "age"))
        
        print("------ number validation check----")
        print(ValidationUtils.isNumber(string: "1213324545A"))
        print(ValidationUtils.isNumber(string: "ABCD"))
        print(ValidationUtils.isNumber(string: "test"))
        print(ValidationUtils.isNumber(string: "12356"))
        print(ValidationUtils.isNumber(string: "12.25"))
        
        print("------ string validation check----")
        var x = ValidationUtils.isEqualString(string1: "Vipul", string2: "Vipul")
        print(x)
        
        x = ValidationUtils.isEqualString(string1: "Vipul", string2: "Chauhan")
        print(x)
        
        x = ValidationUtils.isEqualString(string1: "Vipul", string2: " Vipul ")
        print(x)
        
        x = ValidationUtils.isEqualString(string1: "Vipul", string2: " Vipul")
        print(x)
        
        x = ValidationUtils.isEqualString(string1: "Vipul", string2: "Vipul ")
        print(x)
        
        
        x = ValidationUtils.isEqualStringByIgnoreCase(string1: "Vipul", string2: "VIP")
        print(x)
        
        x = ValidationUtils.isEqualStringByIgnoreCase(string1: "Vipul", string2: "Chauhan")
        print(x)
        
        x = ValidationUtils.isEqualStringByIgnoreCase(string1: "Vipul", string2: " Vipul ")
        print(x)
        
        x = ValidationUtils.isEqualStringByIgnoreCase(string1: "Vipul", string2: " Vipul")
        print(x)
        
        x = ValidationUtils.isEqualStringByIgnoreCase(string1: "Vipul", string2: "Vipul ")
        print(x)

        print("------ alphanumeric check----")
        print("vipul1235".isAlphanumericWithSpace)
        print("vipul1235".isAlphanumericWithSpace)
        print("12254585".isAlphanumericWithSpace)
        print("111!!!25".isAlphanumericWithSpace)
        print("??dfdferer".isAlphanumericWithSpace)
        print("@@1582@@".isAlphanumericWithSpace)
        print("---".isAlphanumericWithSpace)
        print("vipul chauhan".isAlphanumericWithSpace)
        print("".isAlphanumericWithSpace)
        
        print("------ isCharactersOnly check----")
        print("".isCharactersOnly)
        print("1212".isCharactersOnly)
        print("avcd".isCharactersOnly)
        print("1abd2".isCharactersOnly)
        print("asafAFAS".isCharactersOnly)
        
        

        
    }
    
    
    
}
