//
//  NotificationManager.swift
//  ToDoAppIOS
//
//  Created by Рома Котков on 06.10.2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private let requestedKey = "hasRequestedNotificationPermission"
    private let grantedKey = "notificationPermissionGranted"
    private let defaults = UserDefaults.standard

    private init() {}

    // Проверяет, было ли уже запрошено разрешение
    var didRequestPermission: Bool {
        defaults.bool(forKey: requestedKey)
    }

    // Проверяет, разрешены ли уведомления
    var isPermissionGranted: Bool {
        defaults.bool(forKey: grantedKey)
    }

    // Запрашивает разрешение и сохраняет результат
    func requestPermission(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            self.defaults.set(true, forKey: self.requestedKey)
            self.defaults.set(granted, forKey: self.grantedKey)
            completion?(granted)
        }
    }

    // Создаёт напоминание
    func schedule(title: String, body: String, date: Date, taskId: String, repeats: Bool = false, completion: ((Error?) -> Void)? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        content.userInfo = ["taskId": taskId]

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
    // Удаляет напоминание по id задачи
    func cancelReminder(for taskId: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let idsToRemove = requests
                .filter { $0.content.userInfo["taskId"] as? String == taskId }
                .map { $0.identifier }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idsToRemove)
        }
    }
}
