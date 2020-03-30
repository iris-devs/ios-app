//
//  Notifications.swift
//  medcat
//
//  Created by Vitali Stsepaniuk on 29.03.20.
//  Copyright © 2020 Vitali Stsepaniuk. All rights reserved.
//

import Foundation
import UserNotifications

struct LocalNotification: Identifiable {
  var id: String
  var title: String
}

class LocalNotificationManager {  
  static let shared = LocalNotificationManager()
  
  var notifications = [LocalNotification]()
  var isAvailable = false
  
  func requestPermission() {
    UNUserNotificationCenter
      .current()
      .requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
        self.isAvailable = granted
    }
  }
  
  func add(title: String) {
    notifications.append(LocalNotification(
      id: UUID().uuidString,
      title: title
    ))
  }
  
  func scheduleNotifications() {
    for notification in notifications {
      let content = UNMutableNotificationContent()
      content.title = notification.title

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

      UNUserNotificationCenter.current().add(request) { error in
        guard error == nil else {
          print("\(error!.localizedDescription)")
          return
        }
        print("Scheduling notification with id: \(notification.id)")
      }
    }
  }
  
  func checkIsAllowed() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      switch settings.authorizationStatus {
        case .notDetermined:
          self.requestPermission()
        case .authorized, .provisional:
          self.isAvailable = true
        default:
          break
      }
    }
  }
}
