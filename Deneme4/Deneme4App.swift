//
//  Deneme4App.swift
//  Deneme4
//
//  Created by Eren on 22.05.2024.
//

import SwiftUI
import Firebase

@main
struct Deneme4App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
            
        }
        
        
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? =
                     nil) -> Bool {
                    FirebaseApp.configure()
                    return true

    }
}