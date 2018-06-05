//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Kristopher Devlin on 26/05/2018.
//  Copyright © 2018 Vestego. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
}
