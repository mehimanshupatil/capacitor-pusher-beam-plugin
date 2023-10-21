import Foundation
import Capacitor
import PushNotifications
 
enum PushNotificationsPermissions: String {
    case prompt
    case denied
    case granted
}
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(PusherBeamPluginPlugin)
public class PusherBeamPluginPlugin: CAPPlugin {
    private let implementation = PusherBeamPlugin()

    
private let notificationDelegateHandler = PushNotificationsHandler()
 
    let beamsClient = PushNotifications.shared

 override public func load() {
        self.bridge?.notificationRouter.pushNotificationHandler = self.notificationDelegateHandler
        self.notificationDelegateHandler.plugin = self
 
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
     /**
     * Request notification permission
     */
    @objc override public func requestPermissions(_ call: CAPPluginCall) {
        self.notificationDelegateHandler.requestPermissions { granted, error in
            guard error == nil else {
                if let err = error {
                    call.reject(err.localizedDescription)
                    return
                }

                call.reject("unknown error in permissions request")
                return
            }

            var result: PushNotificationsPermissions = .denied

            if granted {
                result = .granted
            }

            call.resolve(["receive": result.rawValue])
        }
    }

    /**
     * Check notification permission
     */
    @objc override public func checkPermissions(_ call: CAPPluginCall) {
        self.notificationDelegateHandler.checkPermissions { status in
            var result: PushNotificationsPermissions = .prompt

            switch status {
            case .notDetermined:
                result = .prompt
            case .denied:
                result = .denied
            case .ephemeral, .authorized, .provisional:
                result = .granted
            @unknown default:
                result = .prompt
            }

            call.resolve(["receive": result.rawValue])
        }
    }
    
    @objc func addDeviceInterest(_ call: CAPPluginCall) {
        let interest = call.getString("interest") ?? ""
        
        try? self.beamsClient.addDeviceInterest(interest: interest)
        call.resolve([
            "interest": interest
        ])
    }
    
    @objc func removeDeviceInterest(_ call: CAPPluginCall) {
        let interest = call.getString("interest") ?? ""
        try? self.beamsClient.removeDeviceInterest(interest: interest)
        call.resolve()
    }
    
    @objc func getDeviceInterests(_ call: CAPPluginCall) {
        let interests: [String] = self.beamsClient.getDeviceInterests() ?? []
        call.resolve([
            "interests": interests
        ])
    }
    
    @objc func setDeviceInterests(_ call: CAPPluginCall) {
        print(call.options["interests"])
        guard let interests = call.options["interests"] as? [String] else {
            call.reject("Interests must be provided in array type")
            return
        }
        
        try? self.beamsClient.setDeviceInterests(interests: interests)
        call.resolve([
            "interests": interests,
            "success": true
        ])
    }
    
    @objc func clearDeviceInterests(_ call: CAPPluginCall) {
        try? self.beamsClient.clearDeviceInterests()
        print("Cleared device interests!")
        call.resolve()
    }
    
    func correctAges(headers:[String:Any])->[String:String] {
        var result:[String:String] = [:]
        for (key, val) in headers {
            result[key] = String(describing: val)
        }
        return result
    }
    
    @objc func setUserID(_ call: CAPPluginCall) {
        let beamsAuthURl = call.getString("beamsAuthURL") ?? "";
        let userId = call.getString("userID") ?? "";
        let headersParams = call.getObject("headers") ?? [:];
        print(headersParams);
        
        let tokenProvider = BeamsTokenProvider(authURL: beamsAuthURl) { () -> AuthData in
            let headers: [String: String] = self.correctAges(headers: headersParams);
            let queryParams: [String: String] = [:] // URL query params your auth endpoint needs
            return AuthData(headers: headers, queryParams: queryParams)
        }

        self.beamsClient.setUserId(userId, tokenProvider: tokenProvider, completion: { error in
            guard error == nil else {
                print(error.debugDescription)
                return
            }

            print("Successfully authenticated with Pusher Beams")
            call.resolve([
                "associatedUser": userId
            ])
        })
    }
    
    @objc func clearAllState(_ call: CAPPluginCall) {
        self.beamsClient.clearAllState {
            print("state cleared")
        }
        call.resolve()
    }

    @objc func stop(_ call: CAPPluginCall) {
        self.beamsClient.stop{
            print("Stopped!")
        }
        call.resolve()
    }
}
