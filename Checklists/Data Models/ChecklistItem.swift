//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Nguyen Van An on 16/05/2018.
//  Copyright © 2018 An. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID: Int
    
    override init() {
        itemID = DataModel.nextChecklistID()
        super.init()
    }
    
    deinit {
        removeNotification()
    }

    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification() {
        
        removeNotification()
        
        if shouldRemind && dueDate > Date() {
            //1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            //2
            let calender = Calendar(identifier: .gregorian)
            let components = calender.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            
            //3
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            //4
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            //5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request) for itemID: \(itemID)")
            
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }

}
