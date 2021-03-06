import Foundation
import UIKit


var answerCall: Bool = false

struct theLinphone {
    static var lc: OpaquePointer?
    static var lct: LinphoneCoreVTable?
    static var manager: LinphoneManager?
}

let registrationStateChanged: LinphoneCoreRegistrationStateChangedCb  = {
    (lc: Optional<OpaquePointer>, proxyConfig: Optional<OpaquePointer>, state: _LinphoneRegistrationState, message: Optional<UnsafePointer<Int8>>) in
    
    switch state{
    case LinphoneRegistrationNone: /**<Initial state for registrations */
        NSLog("LinphoneRegistrationNone")
        
    case LinphoneRegistrationProgress:
        NSLog("LinphoneRegistrationProgress")
        
    case LinphoneRegistrationOk:
        NSLog("LinphoneRegistrationOk")
        
    case LinphoneRegistrationCleared:
        NSLog("LinphoneRegistrationCleared")
        
    case LinphoneRegistrationFailed:
        NSLog("LinphoneRegistrationFailed")
        
    default:
        NSLog("Unkown registration state")
    }
} as LinphoneCoreRegistrationStateChangedCb

let callStateChanged: LinphoneCoreCallStateChangedCb = {
    (lc: Optional<OpaquePointer>, call: Optional<OpaquePointer>, callSate: LinphoneCallState,  message: Optional<UnsafePointer<Int8>>) in
    
    switch callSate{
    case LinphoneCallIncomingReceived: /**<This is a new incoming call */
        NSLog("callStateChanged: LinphoneCallIncomingReceived")
        
        if answerCall{
            ms_usleep(3 * 1000 * 1000); // Wait 3 seconds to pickup
            linphone_core_accept_call(lc, call)
        }
        
    case LinphoneCallStreamsRunning: /**<The media streams are established and running*/
        NSLog("callStateChanged: LinphoneCallStreamsRunning")
        
    case LinphoneCallError: /**<The call encountered an error*/
        NSLog("callStateChanged: LinphoneCallError")
        
    default:
        NSLog("Default call state")
    }
}


class LinphoneManager {
    
    static var iterateTimer: Timer?
    
    init() {
      //  setElements()
    }
    
    func setElements() {
        theLinphone.lct = LinphoneCoreVTable()
        
        // Enable debug log to stdout
        linphone_core_set_log_file(nil)
        linphone_core_set_log_level(ORTP_DEBUG)
        
        // Load config
        let configFilename = documentFile("linphonerc222")
        let factoryConfigFilename = bundleFile("linphonerc-factory")
        
        let configFilenamePtr: UnsafePointer<Int8> = configFilename.cString(using: String.Encoding.utf8.rawValue)!
        let factoryConfigFilenamePtr: UnsafePointer<Int8> = factoryConfigFilename.cString(using: String.Encoding.utf8.rawValue)!
        let lpConfig = lp_config_new_with_factory(configFilenamePtr, factoryConfigFilenamePtr)
        
        // Set Callback
        
        theLinphone.lct?.registration_state_changed = registrationStateChanged
        theLinphone.lct?.call_state_changed = callStateChanged
        
        theLinphone.lc = linphone_core_new_with_config(&theLinphone.lct!, lpConfig, nil)
        print("helloooooooooo");
        
        // Set ring asset
        let ringbackPath = URL(fileURLWithPath: Bundle.main.bundlePath).appendingPathComponent("ringback.wav").absoluteString
        linphone_core_set_ringback(theLinphone.lc, ringbackPath)
        
        let localRing = URL(fileURLWithPath: Bundle.main.bundlePath).appendingPathComponent("toy-mono.wav").absoluteString
        linphone_core_set_ring(theLinphone.lc, localRing)
    }
    
    
    
    fileprivate func bundleFile(_ file: NSString) -> NSString{
        return Bundle.main.path(forResource: file.deletingPathExtension, ofType: file.pathExtension)! as NSString
    }
    
    fileprivate func documentFile(_ file: NSString) -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentsPath: NSString = paths[0] as NSString
        return documentsPath.appendingPathComponent(file as String) as NSString
    }
    
    
    //
    // This is the start point to know how linphone library works.
    //
    func demo() {
        //  makeCall()
        //        autoPickImcomingCall()
        //  idle()
    }
    
    func makeCall(calleeAccount:String){
        
        guard let _ = setIdentify() else {
            print("no identity")
            return;
        }
        linphone_core_invite(theLinphone.lc, calleeAccount)
        setTimer()
        //        shutdown()
    }
    
    func receiveCall(){
        guard let proxyConfig = setIdentify() else {
            print("no identity")
            return;
        }
        register(proxyConfig)
        setTimer()
        //        shutdown()
    }
    
    func idle(){
        guard let proxyConfig = setIdentify() else {
            print("no identity")
            return;
        }
        
        register(proxyConfig)
        setTimer()
        //        shutdown()
    }
    
    func getCallTimer()-> Int32{
        let time = linphone_core_get_current_call_duration(theLinphone.lc)
        print("check time ---->>> \(time)")
        return time
    }
    
    func call_disconnect(){
       // unregister(theLinphone.lc!)
       
        linphone_core_terminate_all_calls(theLinphone.lc)
        LinphoneManager.iterateTimer?.invalidate()
        LinphoneManager.iterateTimer = nil;
       
    }
    
    func mic_enable(){
        NSLog("mic_enable ---->>> ")
        linphone_core_enable_mic(theLinphone.lc, 1)
    }
    
    func mic_disable(){
        NSLog("mic_disable ---->>> ")
        linphone_core_enable_mic(theLinphone.lc, 0)
    }
    
    func setIdentify() -> OpaquePointer? {
        
        // Reference: http://www.linphone.org/docs/liblinphone/group__registration__tutorials.html
        
        //        let path = Bundle.main.path(forResource: "Secret", ofType: "plist")
        //        let dict = NSDictionary(contentsOfFile: path!)
        //        let account = dict?.object(forKey: "account") as! String
        //        let password = dict?.object(forKey: "password") as! String
        //        let domain = dict?.object(forKey: "domain") as! String
        
           let account = UserDefaults.standard.object(forKey: "phonecallusername") as! String
        //"Anil.Kumar_a"
        print("account --------->>> \(account)")
        
        let password = UserDefaults.standard.object(forKey: "phonecallsecret") as! String
        // "anil@123"
        let domain = "metavoxx.net"
        
        let identity = "sip:" + account + "@" + domain;
        
        
        /*create proxy config*/
        let proxy_cfg = linphone_proxy_config_new();
        
        /*parse identity*/
        let from = linphone_address_new(identity);
        
        if (from == nil){
            // NSLog("\(identity) not a valid sip uri, must be like sip:toto@sip.linphone.org");
            return nil
        }
        
        let info=linphone_auth_info_new(linphone_address_get_username(from), nil, password, nil, nil, nil); /*create authentication structure from identity*/
        linphone_core_add_auth_info(theLinphone.lc, info); /*add authentication info to LinphoneCore*/
        
        // configure proxy entries
        linphone_proxy_config_set_identity(proxy_cfg, identity); /*set identity with user name and domain*/
        let server_addr = String(cString: linphone_address_get_domain(from)); /*extract domain address from identity*/
        
        linphone_address_destroy(from); /*release resource*/
        
        linphone_proxy_config_set_server_addr(proxy_cfg, server_addr); /* we assume domain = proxy server address*/
       // linphone_proxy_config_enable_register(proxy_cfg, 0); /* activate registration for this proxy config*/
         linphone_proxy_config_set_expires(proxy_cfg, 60)
        linphone_core_add_proxy_config(theLinphone.lc, proxy_cfg); /*add proxy config to linphone core*/
        linphone_core_set_default_proxy_config(theLinphone.lc, proxy_cfg); /*set to default proxy*/
        
        return proxy_cfg!
    }
    
    func register(_ proxy_cfg: OpaquePointer){
        linphone_proxy_config_enable_register(proxy_cfg, 1); /* activate registration for this proxy config*/
    }
    
    func unregister(_ proxy_cfg:OpaquePointer){
         linphone_proxy_config_enable_register(proxy_cfg, 0);
         linphone_proxy_config_set_expires(proxy_cfg, 60)
          linphone_proxy_config_done(proxy_cfg);
      //   linphone_core_destroy(theLinphone.lc);
//         let proxy_cfg = linphone_proxy_config_new();
//        linphone_core_set_default_proxy_config(theLinphone.lc, proxy_cfg)
//         linphone_core_set_default_proxy_config(theLinphone.lc, proxy_cfg);
//           linphone_proxy_config_enable_register(proxy_cfg, 0);
//
    }
    
    
    
    func shutdown(){
        NSLog("Shutdown..")
        
        let proxy_cfg = linphone_core_get_default_proxy_config(theLinphone.lc); /* get default proxy config*/
        linphone_proxy_config_edit(proxy_cfg); /*start editing proxy configuration*/
        linphone_proxy_config_enable_register(proxy_cfg, 0); /*de-activate registration for this proxy config*/
        linphone_proxy_config_done(proxy_cfg); /*initiate REGISTER with expire = 0*/
        while(linphone_proxy_config_get_state(proxy_cfg) !=  LinphoneRegistrationCleared){
            linphone_core_iterate(theLinphone.lc); /*to make sure we receive call backs before shutting down*/
            ms_usleep(50000);
        }
        
        linphone_core_destroy(theLinphone.lc);
    }
    
    @objc func iterate(){
        if let lc = theLinphone.lc{
            linphone_core_iterate(lc); /* first iterate initiates registration */
        }
        
    }
    
    fileprivate func setTimer(){
        LinphoneManager.iterateTimer = Timer.scheduledTimer(
            timeInterval: 0.02, target: self, selector: #selector(iterate), userInfo: nil, repeats: true)
    }
    
    func allCalls(){
        let aaa = linphone_core_get_calls(theLinphone.lc)
        print("calls logs dataa  : ----\(String(describing: aaa))")
       
        let count = linphone_core_get_call
        print("calls logs count  : ----\(String(describing: count))")
          let  bc = linphone_core_get_calls(theLinphone.lc);
          print("calls logs data islllll-----  : ----\(String(describing: bc))")
      let bb = linphone_core_terminate_conference(theLinphone.lc)
        print("term ------- calls :----\(bb)")
    }
    
//    func allCallLogs() {
//        callLog = NULL;
//        if (_callLogId) {
//            const MSList *list = linphone_core_get_call_logs(theLinphone.lc);
//            while (list != NULL) {
//                LinphoneCallLog *log = (LinphoneCallLog *)list->data;
//                const char *cid = linphone_call_log_get_call_id(log);
//                if (cid != NULL && [_callLogId isEqualToString:[NSString stringWithUTF8String:cid]]) {
//                    callLog = log;
//                    break;
//                }
//                list = list->next;
//            }
//        }
//    }
    
    
}
