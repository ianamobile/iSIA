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
    let FETCH_ORIGIN_LOCATION_LIST_URI = "SIA/getOriginLocationList"
    let FETCH_EQUIP_LOCATION_LIST_URI = "SIA/getEquipmentLocationList"
    let GET_LIST_COMPANYNAME_SCAC = "SIA/getCompanyNameAndSCACByCompanyName"
    
    
    let ORIGINAL_LOCATION = "OriginalLocation"
    let EQUIPMENT_LOCATION = "EquipmentLocation"
    
    let menuTitleArr :[String]  = [  "Notification of Available Equipment",
                                     "Search Equipment Availability",
                                     "Initiate Street Interchange",
                                     "Search Interchange Requests",
                                     "Initiate Street Turn",
                                     "Search Interchange Requests Submitted By you",
                                     "List EP Users",
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
    let menuSegueArr :[String]  = ["notifAvailSegue","notifAvailSearchSegue", "initiateInterchangeSegue", "searchInterchangeReqSegue", "initiateStreetTurnReqSegue", "workDoneByTPUSegue", "listEPUserSegue" , "", "", "", "", "", "", "", "", "", "", "", "", "", "logoutSegue"]
}



