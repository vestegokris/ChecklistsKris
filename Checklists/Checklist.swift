//
//  Checklist.swift
//  Checklists
//
//  Created by Kristopher Devlin on 04/06/2018.
//  Copyright © 2018 Vestego. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    var name = ""
    var items = [ChecklistItem]()

    init(name: String){
        self.name = name
        super.init()
    }
    
}


