//
//  CategoryOfItem.swift
//  Todoey
//
//  Created by Tomasz Bochenek on 21/10/2019.
//  Copyright © 2019 Tomasz Bochenek. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryOfItem: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
