//
//  InternetConnectionManager.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/15/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import Foundation
import Reachability

class InternetConnectionManager: NSObject {

    var reachability: Reachability!
    
    static let sharedInstance: InternetConnectionManager = { return InternetConnectionManager() }()
    
    
    override init() {
        super.init()

        reachability = Reachability()!

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    
    static func stopNotifier() -> Void {
        do {
            try (InternetConnectionManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }

    static func isReachable(completed: @escaping (InternetConnectionManager) -> Void) {
        if (InternetConnectionManager.sharedInstance.reachability).connection != .none {
            completed(InternetConnectionManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (InternetConnectionManager) -> Void) {
        if (InternetConnectionManager.sharedInstance.reachability).connection == .none {
            completed(InternetConnectionManager.sharedInstance)
        }
    }
    
    static func isReachableViaWWAN(completed: @escaping (InternetConnectionManager) -> Void) {
        if (InternetConnectionManager.sharedInstance.reachability).connection == .cellular {
            completed(InternetConnectionManager.sharedInstance)
        }
    }

    static func isReachableViaWiFi(completed: @escaping (InternetConnectionManager) -> Void) {
        if (InternetConnectionManager.sharedInstance.reachability).connection == .wifi {
            completed(InternetConnectionManager.sharedInstance)
        }
    }
}
