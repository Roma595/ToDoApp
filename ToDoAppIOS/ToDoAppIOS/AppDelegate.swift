//
//  AppDelegate.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import Foundation
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().delegate = self
        
        if !NotificationManager.shared.didRequestPermission {
            NotificationManager.shared.requestPermission()
        }
        return true
    }

    // Показывать уведомления в foreground (когда приложение открыто)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
