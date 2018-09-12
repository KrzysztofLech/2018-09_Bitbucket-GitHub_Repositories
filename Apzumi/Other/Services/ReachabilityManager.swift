//
//  ReachabilityManager.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 12.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    var reachability = Reachability()!
    private var firstNotifycation = true
    
    func isReachable() -> Bool {
        return reachability.connection != .none
    }
    
    func startMonitoring() {
        reachability.whenReachable = { reachability in
            if !self.firstNotifycation {
                
                if reachability.connection == .wifi {
                    if !self.firstNotifycation {
                        alertWithNoButton(title: "Internet available", message: "Via WiFi")
                    }
                    print("Reachable via WiFi")
                    
                } else {
                    if !self.firstNotifycation {
                        alertWithNoButton(title: "Internet available", message: "Via Cellular")
                    }
                    print("Reachable via Cellular")
                }
                
            } else {
                self.firstNotifycation = false
            }
        }
        
        reachability.whenUnreachable = { _ in
            if !self.firstNotifycation  {
                alertWithOneButton(title: "Internet not available",
                                 message: "Don't worry. Your data is cached.",
                             buttonTitle: "OK",
                             buttonStyle: .default,
                              completion: {_ in})
            }
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
    }
}
