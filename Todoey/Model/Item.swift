//
//  Item.swift
//  Todoey
//
//  Created by Tomasz Bochenek on 21/10/2019.
//  Copyright © 2019 Tomasz Bochenek. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects.init(fromType: CategoryOfItem.self, property: "items")
}
