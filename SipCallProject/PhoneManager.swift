//
//  aaa.swift
//  SipCallProject
//
//  Created by lhitservices on 08/04/2019.
//  Copyright © 2019 lhitservices. All rights reserved.
//

import Foundation
import UIKit

  class PhoneManager:NSObject {

   
    var linphoneManager = LinphoneManager()
    
   // var linphoneManager:LinphoneManager
            override init() {
    
         // linphoneManager = LinphoneManager()
              //  lin.makeCall()
            }
    
    
    @objc func setElements()
    {
        linphoneManager.setElements()
    }
    
    @objc func calls()
    {
       linphoneManager.allCalls()
    }
    
    @objc func call_phone(callAcc:String){
        linphoneManager.makeCall(calleeAccount: callAcc)
    }
    
    @objc func call_reject(){
        linphoneManager.call_disconnect()
    }
    @objc func call_unmute(){
        linphoneManager.mic_enable()
    }
    @objc func call_mute(){
        linphoneManager.mic_disable()
    }
    
    @objc func getTime() -> Int32{
        return linphoneManager.getCallTimer()
    }
}
