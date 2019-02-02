//
//  CommsProvider.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import Alamofire
import Reachability


class CommsProvider: NSObject {
    
    var reachability: Reachability!
    
    fileprivate static var _sharedInstance: CommsProvider?
    /** Get the singleton instance of CommsProvider. */
    class var sharedInstance : CommsProvider {
        guard let shared = _sharedInstance else {
            _sharedInstance = CommsProvider()
            return _sharedInstance!
        }
        return shared
    }
    
    /** Used to destroy the shared instance when the singleton is not required. */
    func destroy() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        CommsProvider._sharedInstance = nil
    }
    
    //MARK:-
    
    override init() {
        super.init()
        // initialize
        reachability = Reachability()!
        
        // Register for observer
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start reachability notifier")
        }
        
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (CommsProvider.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (CommsProvider) -> Void) {
        if (CommsProvider.sharedInstance.reachability).connection != .none {
            completed(CommsProvider.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (CommsProvider) -> Void) {
        if (CommsProvider.sharedInstance.reachability).connection == .none {
            completed(CommsProvider.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (CommsProvider) -> Void) {
        if (CommsProvider.sharedInstance.reachability).connection == .cellular {
            completed(CommsProvider.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (CommsProvider) -> Void) {
        if (CommsProvider.sharedInstance.reachability).connection == .wifi {
            completed(CommsProvider.sharedInstance)
        }
    }
    
    
    //MARK:- Requests
    func request(type: RequestType, params:[String:Any]?, completionHandler: @escaping (Any?, Error?)->()) {
        switch type {
        case .getSmallcaseDetailData:
            var url = BASE_URL_API + RequestType.getSmallcaseDetailData.rawValue
            if let param = params {
                if let scid = param["scid"] as? String {
                    url.append("?scid=\(scid)")
                }
            }
            
            Alamofire.request(url).responseJSON { (response) in
                if let result = response.result.value {
                    completionHandler(result, nil)
                } else if let error = response.result.error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(nil, nil)
                }
            }
            
            
        case .getHistoricalData:
            var url = BASE_URL_API + RequestType.getHistoricalData.rawValue
            if let param = params {
                if let scid = param["scid"] as? String {
                    url.append("?scid=\(scid)")
                }
                if let duration = param["duration"] as? String {
                    url.append("&duration=\(duration)")
                }
            }
            
            Alamofire.request(url).responseJSON { (response) in
                if let result = response.result.value {
                    completionHandler(result, nil)
                } else if let error = response.result.error {
                    completionHandler(nil, error)
                } else {
                    completionHandler(nil, nil)
                }
            }
        }
    }
    
    
    
    
    
}
