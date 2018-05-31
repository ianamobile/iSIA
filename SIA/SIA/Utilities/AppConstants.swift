//
//  AppConstants.swift
//  BOES
//
//  Created by Piyush Panchal on 8/3/17.
//  Copyright © 2017 Piyush Panchal. All rights reserved.
//

import Foundation


public class AppConstants
{
    let LOGOUT_INDEX = 20
    
    let IDDPIN_SCAC = "IDDPIN_SCAC"
    let DRVLIC_STATE_SCAC = "DRVLIC_STATE_SCAC"
    
    //let APPLICATION_TITLE: String = "BOES"
    
    let BASE_URL = "https://siarestuat.uiia.org/SIAREST/rest/"
    let CONTENT_TYPE_KEY = "Content-Type"
    let CONTENT_TYPE_JSON = "application/json"
    
    let LOGIN_URI = "SIA/siaLogin"
    let FORGOT_PASSWORD_URI = "SIA/forgotPassword"
    
    
    let menuTitleArr :[String]  = [  "Notification of Available Equipment",
                                     "Search equipment available for interchange",
                                     "Initiate Interchange Request",
                                     "Search Interchange Request",
                                     "Initiate Street Turn Request",
                                     "Search Interchange Request Submitted By you",
                                     "List EP User",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "",
                                     "Logout"]
    
    let menuIconArr :[String]  = ["plus","search","plus","search","plus","search","search","","","","","","","","","","","","","","logout"]
    let menuSegueArr :[String]  = ["NotifAvailSegue","NotifAvailSearchSegue", "InitiateInterchangeSegue", "SearchInterchangeReqSegue", "InitiateStreetTurnReqSegue", "WorkDoneByTPUSegue", "ListEPUserSegue" , "", "", "", "", "", "", "", "", "", "", "", "", "", "LogoutSegue"]
}



