//
//  AppDelegate.swift
//  Remote Localization Helper
//
//  Created by Muhammed KARAKUL on 9.03.2020.
//  Copyright © 2020 Loodos. All rights reserved.
//

import Cocoa
import Firebase
import FirebaseFirestore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    static let db = Firestore.firestore()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

