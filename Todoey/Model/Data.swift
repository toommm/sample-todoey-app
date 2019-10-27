//
//  Data.swift
//  Todoey
//
//  Created by Tomasz Bochenek on 21/10/2019.
//  Copyright © 2019 Tomasz Bochenek. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
