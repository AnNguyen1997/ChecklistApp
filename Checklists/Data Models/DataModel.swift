//
//  DataModel.swift
//  Checklists
//
//  Created by Nguyen Van An on 20/05/2018.
//  Copyright © 2018 An. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [CheckList]()
    
    
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([CheckList].self, from: data)
                sortChecklists()
            } catch {
                print("Error decoding its array!")
            }
        }
    }
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        })
    }
    
    //Defaults value for UserDefaults
    func registerDefaults() {
        let dictionary: [String:Any] = ["ChecklistIndex" : -1, "FirstTime" : true]
        
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    //Create a list if the app runs for the first time
    func handleFirstTime()  {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = CheckList(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    //Set unique ID for each checklistitem
    class func nextChecklistID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1 , forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}
