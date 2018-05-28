//
//  CheckList.swift
//  Checklists
//
//  Created by Nguyen Van An on 18/05/2018.
//  Copyright © 2018 An. All rights reserved.
//

import UIKit

class CheckList: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    
    var iconName = "No Icon"
    
    init(name : String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }

}
