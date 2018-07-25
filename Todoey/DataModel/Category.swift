//
//  Category.swift
//  Todoey
//
//  Created by Ty Stafford on 7/22/18.
//  Copyright © 2018 Tyler Stafford. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
