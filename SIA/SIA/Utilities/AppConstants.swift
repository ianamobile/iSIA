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
    
    let LOGIN_URI                           = "SIA/siaLogin"
    let FORGOT_PASSWORD_URI                 = "SIA/forgotPassword"
    let FORGOT_USERNAME_URI                 = "SIA/forgotUserName"
    let FETCH_LOCATION_LIST_URI             = "SIA/getLocationList"
    let GET_LIST_COMPANYNAME_SCAC_URI       = "SIA/getCompanyNameAndSCACByCompanyName"
    let VALIDATE_STREET_TURN_URI            = "SIA/validateInitiateInterchangeDetails"
    let SAVE_STREET_TURN_URI                = "SIA/saveInitiateInterchangeDetails"
    let GET_IPESCAC_BY_CHASSIS_ID_URI       = "SIA/getIEPScacByChassisId"
    let SIA_LOOKUP_URI                      = "SIA/siaLookup"
    let LIST_EP_USERS_URI                   = "SIA/getEPUserListByTPU"
    let GET_EQUIP_LIST_URI                  = "SIA/getEquipmentList"
    let DELETE_NOTIFAVAILREQUEST_BY_ID_URI  = "SIA/deleteNotifAvailRequestByNaId"
    let SETUP_PAGE_URI                      = "SIA/setupPage"
    let VALIDATE_NOTIF_AVAIL_DETAILS_URI    = "SIA/validateNotifAvailEquipDetails"
    let SAVE_NOTIF_AVAIL_URI                =  "SIA/addEquipmentToPool"
    let VALIDATE_STREET_INTERCHANGE_REQUEST_URI = "SIA/validateInitiateInterchangeDetails"
    let SAVE_INTERCHANGE_REQUEST_URL        = "SIA/saveInitiateInterchangeDetails"
    let GET_INTERCHANGE_REQUEST_DETAILS     = "SIA/getInterchangeRequestDetails"
    let INTERCHANGE_REQUEST_OPERATIONS = "SIA/interchangeRequestOperations"
    let GET_UIIA_EXHIBIT_LIST           = "SIA/getUIIAExhibitList"
    
    let ORIGINAL_LOCATION = "OriginalLocation"
    let EQUIPMENT_LOCATION = "EquipmentLocation"
    
    let OPT_APPROVE = "APPROVE"
    let OPT_REJECT = "REJECT"
    let OPT_ONHOLD = "ONHOLD"
    let OPT_REINSTATE = "REINSTATE"
    let OPT_CANCEL = "CANCEL"
    
    
    
    let menuTitleArr :[String]  = [  "Notification of Available Equipment",
                                     "Search Equipment Availability",
                                     "Initiate Street Interchange",
                                     "Search Interchange Requests",
                                     "Initiate Street Turn",
                                     "Search Interchange Requests Submitted By you",
                                     "List EP Users",
                                     "Pending Interchange Requests",
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
    
    let menuIconArr :[String]  = ["plus","search","plus","search","plus","search","menu","pending_hourglass","","","","","","","","","","","","","logout"]
    let menuSegueArr :[String]  = ["notifAvailSegue","notifAvailSearchSegue", "initiateInterchangeSegue", "searchInterchangeReqSegue", "initiateStreetTurnReqSegue", "workDoneByTPUSegue", "listEPUserSegue" , "pendingInterchangeReqSegue", "", "", "", "", "", "", "", "", "", "", "", "", "logoutSegue"]

    let ERROR_MSG = "Opp! An error has occured, please try after some time."
}



