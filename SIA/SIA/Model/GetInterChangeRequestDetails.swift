//
//  GetInterChangeRequestDetails.swift
//  SIA
//
//  Created by Piyush Panchal on 7/9/18.
//  Copyright © 2018 Piyush Panchal. All rights reserved.
//

import Foundation

class GetInterChangeRequestDetails{
    
    var interchangeRequests : InterchangeRequests = InterchangeRequests()
    var uiiaExhibitDataList = [UIIAExhibitData]()
    var workFlowList = [WorkFlow]()
    var inProcessWf : WorkFlow = WorkFlow()
    
    var isEPUser  :String?
    var uiiaExhibitInputReq :String?
    
    var showReinstateButton :String?
    var showButtons :String?
    var showCancelButtons :String?
    var holdButtonShow : String?
    var loggedInUserEligibleForApproval: Bool?
    
    init() {
        
    }
    
    init(_ data: [String : Any]) {
        
        if !data.isEmpty
        {
            if let irJsonDictionary:[String : Any]   = data["interchangeRequests"] as? [String : Any]
            {
                    self.interchangeRequests = InterchangeRequests(irJsonDictionary)
            }
            
            if let jsonArray:NSArray   = data["workFlowList"] as? NSArray
            {
                for tempObj in jsonArray
                {
                    
                    let obj = tempObj as! [String: Any]
                    let workFlowObj: WorkFlow = WorkFlow(obj)
                    self.workFlowList.append(workFlowObj)
                    
                }
                
            }
            if let jsonArray:NSArray   = data["uiiaExhibitDataList"] as? NSArray
            {
                for tempObj in jsonArray
                {
                    
                    let obj = tempObj as! [String: Any]
                    let exhibitDataObj: UIIAExhibitData = UIIAExhibitData(obj)
                    self.uiiaExhibitDataList.append(exhibitDataObj)
                    
                }
                
            }
            if let inProgressWFJsonDictionary:[String : Any]   = data["inProcessWf"] as? [String : Any]
            {
                self.inProcessWf = WorkFlow(inProgressWFJsonDictionary)
            }
            
            //seperate fields.
            self.isEPUser =  data["isEPUser"] as? String
            self.uiiaExhibitInputReq    = data["uiiaExhibitInputReq"] as? String
            self.showReinstateButton    = data["showReinstateButton"] as? String
            self.showButtons    = data["showButtons"] as? String
            self.showCancelButtons    = data["showCancelButtons"] as? String
            self.holdButtonShow    = data["holdButtonShow"] as? String
            self.loggedInUserEligibleForApproval    = data["loggedInUserEligibleForApproval"] as? Bool
            
        }
    }
    
    
    
}
class InterchangeRequests {
   
    var irId : Int?
    var naId : String?
    var irNum : String?
    var intchgType : String?
    
    var mcACompanyName : String?
    var mcBCompanyName : String?
    var epCompanyName : String?
    var epScacs : String?
    var mcAScac : String?
    var mcBScac : String?
    
    var bookingNum : String?
    var importBookingNum : String?
    var contNum : String?
    var contSize : String?
    var contType : String?
    var chassisSize : String?
    var chassisType : String?
    var chassisNum : String?
    var iepScac : String?
    var gensetNum : String?
    
    var equipLocSplcCode : String?
    var equipLocIanaCode : String?
    var equipLocNm : String?
    var equipLocAddr : String?
    var equipLocCity : String?
    var equipLocState : String?
    var equipLocZip : String?
    
    var originLocSplcCode : String?
    var originLocIanaCode : String?
    var originLocNm : String?
    var originLocAddr : String?
    var originLocCity : String?
    var originLocState : String?
    var originLocZip : String?
    
    var eqCondn : String?
    var status : String?
    var lastApprovedBy : String?
    var email : String?
    var reqType : String?
    var items : String?
    var nonuiia : String?
    var remarks : String?
    var actionRequired : String?
    var irRequestType : String?
    var actionType : String?
    var importBookingNumTemp : String?
    var epApprovedBy : String?
    var epApprovedAt : String?
    var uiiaExhibitStr : String?
    var createdDate : String?
    var modifiedDate : String?
    
    init() {
        
    }
    
    init(_ data: [String : Any]) {
        
        self.irId =  data["irId"] as? Int
        self.irNum =  data["irNum"] as? String
        self.intchgType =  data["intchgType"] as? String
        
        self.mcACompanyName =  data["mcACompanyName"] as? String
        self.mcBCompanyName =  data["mcBCompanyName"] as? String
        self.epCompanyName =  data["epCompanyName"] as? String
        self.epScacs =  data["epScacs"] as? String
        self.mcAScac =  data["mcAScac"] as? String
        self.mcBScac =  data["mcBScac"] as? String
        
        self.bookingNum =  data["bookingNum"] as? String
        self.importBookingNum =  data["importBookingNum"] as? String
        self.contNum =  data["contNum"] as? String
        self.contSize =  data["contSize"] as? String
        self.contType =  data["contType"] as? String
        self.chassisSize =  data["chassisSize"] as? String
        self.chassisType =  data["chassisType"] as? String
        self.chassisNum =  data["chassisNum"] as? String
        self.iepScac =  data["iepScac"] as? String
        self.gensetNum =  data["gensetNum"] as? String
        
        self.equipLocSplcCode = data["equipLocSplcCode"] as? String
        self.equipLocIanaCode = data["equipLocIanaCode"] as? String
        self.equipLocNm = data["equipLocNm"] as? String
        self.equipLocAddr = data["equipLocAddr"] as? String
        self.equipLocCity = data["equipLocCity"] as? String
        self.equipLocState = data["equipLocState"] as? String
        self.equipLocZip = data["equipLocZip"] as? String
        
        self.originLocSplcCode = data["originLocSplcCode"] as? String
        self.originLocIanaCode = data["originLocIanaCode"] as? String
        self.originLocNm = data["originLocNm"] as? String
        self.originLocAddr = data["originLocAddr"] as? String
        self.originLocCity = data["originLocCity"] as? String
        self.originLocState = data["originLocState"] as? String
        self.originLocZip = data["originLocZip"] as? String
        
        self.eqCondn = data["eqCondn"] as? String
        self.status = data["status"] as? String
        self.lastApprovedBy = data["lastApprovedBy"] as? String
        self.email = data["email"] as? String
        self.reqType = data["reqType"] as? String
        self.items = data["items"] as? String
        self.nonuiia = data["nonuiia"] as? String
        self.remarks = data["remarks"] as? String
        self.actionRequired = data["actionRequired"] as? String
        self.irRequestType = data["irRequestType"] as? String
        self.actionType = data["actionType"] as? String
        self.importBookingNumTemp = data["importBookingNumTemp"] as? String
        self.epApprovedBy = data["epApprovedBy"] as? String
        self.epApprovedAt = data["epApprovedAt"] as? String
        self.uiiaExhibitStr = data["uiiaExhibitStr"] as? String
        self.createdDate = data["createdDate"] as? String
        self.modifiedDate = data["modifiedDate"] as? String
        
        
    }
    
}


class WorkFlow {
    
    var wfId : Int?
    var irId : Int?
    var approvedBy :  String?
    var wfSeq : Int?
    var wfSeqType :  String?
    var action :  String?
    var status :  String?
    var approvedDate :  String?
    var displayColor :  String?
    var pid :Int?
   
    init() {
        
    }
    init(_ data: [String : Any]) {
       
        self.wfId =  data["wfId"] as? Int
        self.irId =  data["irId"] as? Int
        self.approvedBy =  data["approvedBy"] as? String
        self.wfSeq =  data["wfSeq"] as? Int
        self.wfSeqType =  data["wfSeqType"] as? String
        self.action =  data["action"] as? String
        self.status =  data["status"] as? String
        self.approvedDate =  data["approvedDate"] as? String
        self.displayColor =  data["displayColor"] as? String
        self.pid =  data["pid"] as? Int
        
    }
    
}

class UIIAExhibitData {
    
    var ueir_id :Int?
    var ir_id : Int?
    var ue_id : Int?
    var created_by : String?
    var created_date : String?
    var item : String?
    var item_no : String?
    var item_desc : String?
  
    init() {
        
    }
    init(_ data: [String : Any]) {
        
        self.ueir_id =  data["ueir_id"] as? Int
        self.ir_id =  data["ir_id"] as? Int
        self.ue_id =  data["ue_id"] as? Int
        self.created_by =  data["created_by"] as? String
        self.created_date =  data["created_date"] as? String
        self.item =  data["item"] as? String
        self.item_no =  data["item_no"] as? String
        self.item_desc =  data["item_desc"] as? String
        
    }
    
}

