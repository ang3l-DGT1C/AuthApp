//
//  AppDelegate.swift
//  AuthApp
//
//  Created by Ángel González on 24/02/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func detectJailBroken () -> Bool {
        /* Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath:"/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath:"/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath:"/bin/bash")
            || FileManager.default.fileExists(atPath:"/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath:"/etc/apt")
            || FileManager.default.fileExists(atPath:"/private/var/lib/apt/")
            || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!) {
            return true
        }*/
        // Check 2 : Reading and writing in system directories (sandbox violation)
        let stringToWrite = "Jailbreak Test"
        do {
            try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            //Device is jailbroken
            return true
        }
        catch {
            return false
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if detectJailBroken() {
            // el dispositivo si está crackeado!! que hago?
            exit(666)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

